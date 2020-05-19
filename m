Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49B61DA3AD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgESVe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:34:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESVe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:34:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLXDpC064727;
        Tue, 19 May 2020 21:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=XvX+z7KKVGBzMZiI3Qgk3gyGUPZ961yy2VHT9Alm848=;
 b=rDoNTc1KHr5fv+G158PN8ibredYUabaKl2NUJ0vZJ/Yu2UE3oZwKq8IC4NZF5W3xuiPr
 4Wq6RcP+3Oy7k3cBGOqI9GF4mLuFfsNWOg5IM+euRgVOHdOpQDjlr+Iy+Pfc9qOyXVWQ
 uUCdtqV8UUR83d7S9rGVQn9XhM7rbpx8PiVzmlSFljrS0iViRQE1FxsXH82VucFYVuME
 52K8Z7vst+rDuf2FujaMTrE7N5dyIwnckHAJFw/VcMgdC1O4Gu7yFLR1Hi3Ug1ORzkCZ
 z47x36FZLDUTXhQdZnbXzrm4GzYhERlM0Qd2AwQf0lQQKlNJBGHdcWXy5uEFDj3gZ/qd 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127kr7y9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:34:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLX1Kj046925;
        Tue, 19 May 2020 21:34:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t35fd4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:34:37 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JLYZcU025379;
        Tue, 19 May 2020 21:34:35 GMT
Received: from dhcp-10-175-213-8.vpn.oracle.com (/10.175.213.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:34:35 -0700
Date:   Tue, 19 May 2020 22:34:25 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        bpf@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests/bpf: add general instructions for
 test execution
In-Reply-To: <20200519155021.6tag46i57z2hsivj@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.LRH.2.21.2005192224560.31696@localhost>
References: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com> <20200519155021.6tag46i57z2hsivj@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020, Alexei Starovoitov wrote:

> On Mon, May 18, 2020 at 12:23:10PM +0100, Alan Maguire wrote:
> > Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
> > are used, pahole is recent (>=1.16) and config matches the specified
> > config file as closely as possible.  Document all of this in the general
> > README.rst file.  Also note how to work around timeout failures.
> > 
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> >  tools/testing/selftests/bpf/README.rst | 46 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
> > index 0f67f1b..b00eebb 100644
> > --- a/tools/testing/selftests/bpf/README.rst
> > +++ b/tools/testing/selftests/bpf/README.rst
> > @@ -1,6 +1,52 @@
> >  ==================
> >  BPF Selftest Notes
> >  ==================
> > +First verify the built kernel config options match the config options
> > +specified in the config file in this directory.  Test failures for
> > +unknown helpers, inability to find BTF etc will be observed otherwise.
> > +
> > +To ensure the maximum number of tests pass, it is best to use the latest
> > +trunk LLVM/clang, i.e.
> > +
> > +git clone https://github.com/llvm/llvm-project
> > +
> > +Build/install trunk LLVM:
> > +
> > +.. code-block:: bash
> > +  git clone https://github.com/llvm/llvm-project
> > +  cd llvm-project
> > +  mkdir build/llvm
> > +  cd build/llvm
> > +  cmake ../../llvm/
> > +  make
> > +  sudo make install
> > +  cd ../../
> > +
> > +Build/install trunk clang:
> > +
> > +.. code-block:: bash
> > +  mkdir -p build/clang
> > +  cd build/clang
> > +  cmake ../../clang
> > +  make
> > +  sudo make install
> > +
> 
> these instructions are obsolete and partially incorrect.
> May be refer to Documentation/bpf/bpf_devel_QA.rst instead?
>

Sure; looks like there are up-to-date sections there on
running BPF selftests and building LLVM manually.  Perhaps
I should add the notes about pahole etc there too?
I should also have noted that without an up-to-date iproute2
failures will be observed also.
  
> > +When building the kernel with CONFIG_DEBUG_INFO_BTF, pahole
> > +version 16 or later is also required for BTF function
> > +support. pahole can be built from the source at
> > +
> > +https://github.com/acmel/dwarves
> > +
> > +It is often available in "dwarves/libdwarves" packages also,
> > +but be aware that versions prior to 1.16 will fail with
> > +errors that functions cannot be found in BTF.
> > +
> > +When running selftests, the default timeout of 45 seconds
> > +can be exceeded by some tests.  We can override the default
> > +timeout via a "settings" file; for example:
> > +
> > +.. code-block:: bash
> > +  echo "timeout=120" > tools/testing/selftests/bpf/settings
> 
> Is it really the case?
> I've never seen anything like this.
> 

When running via "make run_tests" on baremetal systems I
see test timeouts pretty consistently; e.g. from a bpf tree test
run yesterday:

not ok 6 selftests: bpf: test_progs # TIMEOUT
not ok 31 selftests: bpf: test_tunnel.sh # TIMEOUT
not ok 38 selftests: bpf: test_lwt_ip_encap.sh # TIMEOUT
not ok 40 selftests: bpf: test_tc_tunnel.sh # TIMEOUT
not ok 42 selftests: bpf: test_xdping.sh # TIMEOUT
not ok 43 selftests: bpf: test_bpftool_build.sh # TIMEOUT

These will only occur if running via "make run_tests",
so running tests individually would not trigger these
failures.

Alan
