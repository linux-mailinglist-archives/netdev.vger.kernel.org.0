Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCB72D3611
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgLHWOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:14:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHWOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:14:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8M9JOX080288;
        Tue, 8 Dec 2020 22:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=vODya7JNvspo7z4vEUFMHHOowJ4I1WcQwUOxnk+pJSw=;
 b=NqLlXjwzxv6IiHWtyLfnpWHrtg6llJeCEtoCNd3SbUGWsuWqPpggVxZRucAV6h2QGLq3
 k2dg1o/cyqqY0NDVq1sEjuiWDZAEGZbdexLsjd0P5U+tJpWLCm+NPgjfPv861/9ooPZU
 PdZWg0tAfeZrz0Wm7oN6azgDxUkvu1r1jFfoX8SMUkzyjPJsZ4GzvFMwFM8k5v3gEwHR
 wJXCuIUWnB+/9AF6tj7QijfVgs97TInmNnG8grn6QGpupN+TgVoN8+8CB+1iYaJc2DIt
 +fdxWWGrvfXAAMPFsumw4r5dm7LqNHf8nEar8bOZo1uVOCYTyoeisCZ6d4xSz16gVM/P pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqbwccn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 22:13:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MBjSn089223;
        Tue, 8 Dec 2020 22:13:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 358m4yh66x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 22:13:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B8MDfCI030483;
        Tue, 8 Dec 2020 22:13:42 GMT
Received: from dhcp-10-175-161-251.vpn.oracle.com (/10.175.161.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 14:13:41 -0800
Date:   Tue, 8 Dec 2020 22:13:35 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET
 CO-RE relocation
In-Reply-To: <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2012082202450.25628@localhost>
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012071623080.3652@localhost> <20201208031206.26mpjdbrvqljj7vl@ast-mbp> <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=10
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=10 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080138
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020, Andrii Nakryiko wrote:

> On Mon, Dec 7, 2020 at 7:12 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Dec 07, 2020 at 04:38:16PM +0000, Alan Maguire wrote:
> > > Sorry about this Andrii, but I'm a bit stuck here.
> > >
> > > I'm struggling to get tests working where the obj fd is used to designate
> > > the module BTF. Unless I'm missing something there are a few problems:
> > >
> > > - the fd association is removed by libbpf when the BPF program has loaded;
> > > the module fds are closed and the module BTF is discarded.  However even if
> > > that isn't done (and as you mentioned, we could hold onto BTF that is in
> > > use, and I commented out the code that does that to test) - there's
> > > another problem:
> > > - I can't see a way to use the object fd value we set here later in BPF
> > > program context; btf_get_by_fd() returns -EBADF as the fd is associated
> > > with the module BTF in the test's process context, not necessarily in
> > > the context that the BPF program is running.  Would it be possible in this
> > > case to use object id? Or is there another way to handle the fd->module
> > > BTF association that we need to make in BPF program context that I'm
> > > missing?
> > > - A more long-term issue; if we use fds to specify module BTFs and write
> > > the object fd into the program, we can pin the BPF program such that it
> > > outlives fds that refer to its associated BTF.  So unless we pinned the
> > > BTF too, any code that assumed the BTF fd-> module mapping was valid would
> > > start to break once the user-space side went away and the pinned program
> > > persisted.
> >
> > All of the above are not issues. They are features of FD based approach.
> > When the program refers to btf via fd the verifier needs to increment btf's refcnt
> > so it won't go away while the prog is running. For module's BTF it means
> > that the module can be unloaded, but its BTF may stay around if there is a prog
> > that needs to access it.
> > I think the missing piece in the above is that btf_get_by_fd() should be
> > done at load time instead of program run-time.
> > Everything FD based needs to behave similar to map_fds where ld_imm64 insn
> > contains map_fd that gets converted to map_ptr by the verifier at load time.
> 
> Right. I was going to extend verifier to do the same for all used BTF
> objects as part of ksym support for module BTFs. So totally agree.
> Just didn't need it so far.
> 

Does this approach prevent more complex run-time specification of BTF 
object fd though?  For example, I've been working on a simple tracer 
focused on kernel debugging; it uses a BPF map entry for each kernel 
function that is traced. User-space populates the map entry with BTF type 
ids for the function arguments/return value, and when the BPF program 
runs it uses the instruction pointer to look up the map entry for that
function, and uses bpf_snprintf_btf() to write the string representations 
of the function arguments/return values.  I'll send out an RFC soon, 
but longer-term I was hoping to extend it to support module-specific 
types.  Would a dynamic case like that - where the BTF module fd is looked 
up in a map entry during program execution (rather than derived via 
__btf_builtin_type_id()) work too? Thanks!

Alan
