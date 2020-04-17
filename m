Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942151AE33C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgDQRIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:08:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgDQRIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 13:08:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HH8Emn164795;
        Fri, 17 Apr 2020 17:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9AuAKei1InWbZiUi954FqxZ6IMH4o42cp4Zcjvsq5TU=;
 b=GJJsNhUfXpcSqBvF7jDngmW0MRJw+h461HG+bRbezlfBsv0QFGTBw2XqkGRtCcwLu/xX
 WDiT2eLR1yBIaT+Bl3wQShCLJ2z7X9078sV7ywYB83649n8lZXzdtggtusjLA+jLS8yN
 shn8ZekAdpIOwaxXZAvyZvX0wquk7Q8Hx3fJ95gEAJqZlSlDiQ3CDddDmRUznPzV3Msd
 0jlV06+JJe17tuNh/XGqLxgTXktZTmEC9ISSjhbqA/R+xdGdi6BkdWg/yuAhZB9p27Jj
 85fWXr10S7q357QQ2oPsN9aFhZHOO11QLvLw+95z3Jmyq0oRQLS+RReSpYJf7iXmpyug 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30dn9608ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 17:08:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HH3PK2029576;
        Fri, 17 Apr 2020 17:06:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30emerd6j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 17:06:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HH6Obc009578;
        Fri, 17 Apr 2020 17:06:24 GMT
Received: from dhcp-10-175-205-33.vpn.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 10:06:24 -0700
Date:   Fri, 17 Apr 2020 18:06:16 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type
 printing
In-Reply-To: <20200417164747.GD17973@kernel.org>
Message-ID: <alpine.LRH.2.21.2004171803550.29397@localhost>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com> <20200417164747.GD17973@kernel.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=3
 mlxlogscore=999 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=3
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Apr 2020, Arnaldo Carvalho de Melo wrote:

> Em Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire escreveu:
> > To give a flavour for what the printed-out data looks like,
> > here we use pr_info() to display a struct sk_buff *.  Note
> > we specify the 'N' modifier to show type field names:
> > 
> >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > 
> >   pr_info("%pTN<struct sk_buff>", skb);
> > 
> > ...gives us:
> > 
> > {{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,.rb_right=00000000c7916e9c,.rb_left=00000000c7916e9c}|.list={.next=00000000c7916e9c,.prev=00000000c7916e9c}},{.sk=00000000c7916e9c|.ip_defrag_offset=0},{.tstamp=0|.skb_mstamp_ns=0},.cb=['\0'],{{._skb_refdst=0,.destructor=00000000c7916e9c}|.tcp_tsorted_anchor={.next=00000000c7916e9c,.prev=00000000c7916e9c}},._nfct=0,.len=0,.data_len=0,.mac_len=0,.hdr_len=0,.queue_mapping=0,.__cloned_offset=[],.cloned=0x0,.nohdr=0x0,.fclone=0x0,.peeked=0x0,.head_frag=0x0,.pfmemalloc=0x0,.active_extensions=0,.headers_start=[],.__pkt_type_offset=[],.pkt_type=0x0,.ignore_df=0x0,.nf_trace=0x0,.ip_summed=0x0,.ooo_okay=0x0,.l4_hash=0x0,.sw_hash=0x0,.wifi_acked_valid=0x0,.wifi_acked=0x0,.no_fcs=0x0,.encapsulation=0x0,.encap_hdr_csum=0x0,.csum_valid=0x0,.__pkt_vlan_present_offset=[],.vlan_present=0x0,.csum_complete_sw=0x0,.csum_level=0x0,.csum_not_inet=0x0,.dst_pending_co
> 
> One suggestion, to make this more compact, one could have %pTNz<struct
> sk_buff>" that wouldn't print any integral type member that is zeroed
> :-)
>

That's a great idea, thanks Arnaldo! I'll add that.

Alan
 
> - Arnaldo
> 
