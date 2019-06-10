Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AD73C027
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390702AbfFJXtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:49:12 -0400
Received: from mx2.ucr.edu ([138.23.62.3]:56349 "EHLO mx2.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390570AbfFJXtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1560210550; x=1591746550;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=5dpFvE/+juvat/BejnLqmabttoGgZAvR3JWhDuSOis4=;
  b=a0CatwixqVQ35EbMZxQacDzxQ/hGYQd/Vyl3HqHa/zPCiwxR+q9lw/TH
   yHqGll+ipWGYNqWhYqrzSckeY8z1ryPFXJhB9V/zT4umEiqUPNKMNQpVL
   6ifegSRCPsAh0J0BNiZm++d6ew0e/Huf5H9rL9Uegu2joamTCgdlEZBIL
   Ky+y6JLY4mUhQm2mOyQab9hpntzGjJ8lQt2PkcAe9Gnw5U14GTsDXlX7J
   SNDeMKZ0IGwcUPob89Dw91iBsRHwr1h2H6e7ldZfTUgw/vGwLO8E+3tgN
   u9RYZ82ZQNBFTR+CKaK0Isldgp6UYNnmMo312zZ7LPEAJHMoDNygsEoVb
   w==;
IronPort-PHdr: =?us-ascii?q?9a23=3A9T4iqhzy9YMMquXXCy+O+j09IxM/srCxBDY+r6Qd?=
 =?us-ascii?q?1O0eIJqq85mqBkHD//Il1AaPAdyCrasZ0KGM7ujJYi8p2d65qncMcZhBBVcuqP?=
 =?us-ascii?q?49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx7xKRR6?=
 =?us-ascii?q?JvjvGo7Vks+7y/2+94fcbglVmTaxe65+IRW4oAneqMUbgZZpJ7osxBfOvnZGYf?=
 =?us-ascii?q?ldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2Yu5M32rhbD?=
 =?us-ascii?q?VheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RSiu4qF2QxLzli?=
 =?us-ascii?q?wJKyA2/33WisxojaJUvhShpwBkw4XJZI2ZLedycr/Bcd8fQ2dKQ8RfWDFbAo6k?=
 =?us-ascii?q?YIQPAegOM+ZWoYf+ulUAswexCBKwBO/z0DJEmmP60bE43uknDArI3BYgH9ULsH?=
 =?us-ascii?q?nMr9r1NKASUea6zKnKzDXMce5d1jfn54jOfRAqvPaBXLN+cMXLz0kvGB/Jg1qT?=
 =?us-ascii?q?pIH+IjOayv4Nv3KF4OV9SOKikmgqoBxyrDi33soglJXFi4YPxl3H9Sh12pg5Kc?=
 =?us-ascii?q?CkREJhfNKpFJlduieHPIVsWMwiWXtnuCMix70Dvp60YTYFxYw8xx7ad/yHa4+I?=
 =?us-ascii?q?4g//VOqJITd3mnZleLWniha360egy+n8WtCs0FZEsyZJi9fMum0J2hHR8MSHRf?=
 =?us-ascii?q?x9/kCu2TaLyQ/f8P1LIUcxlabDKp4hxKA/loYLvEjdAiP7nF/6gayWe0k+5OSk?=
 =?us-ascii?q?9vjrbq/7qpKYNYJ4kgT+Pb4vmsy7D+Q4KA8OX22D9OW92rzs50v5QLpWgvA5ka?=
 =?us-ascii?q?TUq43aKtgBpqKjHQBaz5sj5w6lDzi6yNQYgWUHLFVddRKBkYfpJ0zBL+7mDfqk?=
 =?us-ascii?q?nVSsnylkx+rcMr3iHJrNNH7Dn6nlfbpn7E5c0gUznphj4MdyB7gFaNn6QEPuud?=
 =?us-ascii?q?jcRks/OAWuz/nqDNFV2YQZVmaCRKSeNfWBn0WP47cdI+6Ka40UtX7CIv4qr6r8?=
 =?us-ascii?q?knY/lgdBLYG01oFRZXylSKc1a36FaGbh149SWVwBuRAzGamz0AWP?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DYAgDr6/5cdcXSVdFcCoNBAjuCGCiEF?=
 =?us-ascii?q?ZUAmHSBEANUAQgBAQEOLwEBhDwCAgKCdCNLAQMBAQUBAQEFARMBCg0KBycxgjo?=
 =?us-ascii?q?pAYJnAQUjBFIQCwsDCgICJgICIhIBBQEcBhODIoILnQ08iyB+M4hiAQcKgUYSe?=
 =?us-ascii?q?iYEi1uCFoQjPoQRAQcLAYMpglgEgS0BAQGTF5N2aQEGAgGBfhOTQhuCJYZ8coM?=
 =?us-ascii?q?SiXYtozkPIYIdMHEzGiV/BmeBToM0AQuNMiIwjT6CQwEB?=
X-IPAS-Result: =?us-ascii?q?A2DYAgDr6/5cdcXSVdFcCoNBAjuCGCiEFZUAmHSBEANUAQg?=
 =?us-ascii?q?BAQEOLwEBhDwCAgKCdCNLAQMBAQUBAQEFARMBCg0KBycxgjopAYJnAQUjBFIQC?=
 =?us-ascii?q?wsDCgICJgICIhIBBQEcBhODIoILnQ08iyB+M4hiAQcKgUYSeiYEi1uCFoQjPoQ?=
 =?us-ascii?q?RAQcLAYMpglgEgS0BAQGTF5N2aQEGAgGBfhOTQhuCJYZ8coMSiXYtozkPIYIdM?=
 =?us-ascii?q?HEzGiV/BmeBToM0AQuNMiIwjT6CQwEB?=
X-IronPort-AV: E=Sophos;i="5.63,577,1557212400"; 
   d="scan'208";a="1065450420"
Received: from mail-pf1-f197.google.com ([209.85.210.197])
  by smtp2.ucr.edu with ESMTP/TLS/AES128-GCM-SHA256; 10 Jun 2019 16:48:32 -0700
Received: by mail-pf1-f197.google.com with SMTP id i26so8250001pfo.22
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CaOoz8j2UMrv32FeXs2WFFwpsAQB5P6Hn1rMuT3jKD8=;
        b=cTAMMGD2iTNDtUeSEPSKxUtEncMIvcp4T/v1zXy5jzKqewYspvB+sMKo9OkzazhYch
         HfIBIVps7lAhn6MevSXAzWb5/BmFqQL2i/97J2WJ073yFTqnGutLh1rxnOuZ6x3bmxH2
         P2cDpknrq7oLToR5FkD3MRkPj6MF85Q+sKc3vebTq/JC1NEbK0boLtGhZ7E6skrq2v0Z
         oPYXaMpLrV6ZO7RC/09hrnChoFxE4s3qhggf6y3n/BeU6eLvwM0sR6Xf/pLEodO/ZDnq
         GP6tzRNVHEcv5tfUZHCw90Q0UONAxfhYyMdiBu8xQL1AdGI5uICxEFe//WC7gQhXUwz0
         lM1Q==
X-Gm-Message-State: APjAAAVbqU0rroWGe9TBMzAyh6bl4+PBBxCLMDg9nr8sDmSYQv0qYEj3
        LPEoWGsVweDV9+MS7XsaS6X5zmhcLB612FXz095ILLK1vsRkmAVm1J+UqlBcWgmvJXlMaFrpdkt
        1rkTLre+Q4EYJv5RPZoqao6AEjlJxHC/7XQ==
X-Received: by 2002:a63:5207:: with SMTP id g7mr17239222pgb.356.1560210511976;
        Mon, 10 Jun 2019 16:48:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwVZw5tOz2gRNkG8Scf318b07opnJz0dJC+0rOglwWZhWHUJEdwJixzrU/aLFCXv9Pwz5jSHNvjXflAoEzQZIk=
X-Received: by 2002:a63:5207:: with SMTP id g7mr17239194pgb.356.1560210511588;
 Mon, 10 Jun 2019 16:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
 <CADVnQymPcJJ-TnsNkZm-r+PrhxHjPLLLiDhf3GjeBjSTGJwbkw@mail.gmail.com>
In-Reply-To: <CADVnQymPcJJ-TnsNkZm-r+PrhxHjPLLLiDhf3GjeBjSTGJwbkw@mail.gmail.com>
From:   Zhongjie Wang <zwang048@ucr.edu>
Date:   Mon, 10 Jun 2019 16:51:34 -0700
Message-ID: <CAHx7fy5bSghKONyYSW-4oXbEKLHUxYC7vE=ZiKLXUED-iuuCdw@mail.gmail.com>
Subject: Re: tp->copied_seq used before assignment in tcp_check_urg
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neal,

Thanks for your reply. Sorry, I made a mistake in my previous email.
After I double checked the source code, I think it should be tp->urg_seq,
which is used before assignment, instead of tp->copied_seq.
Still in the same if-statement:

5189     if (tp->urg_seq == tp->copied_seq && tp->urg_data &&
5190         !sock_flag(sk, SOCK_URGINLINE) && tp->copied_seq != tp->rcv_nxt) {
5191         struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
5192         tp->copied_seq++;
5193         if (skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq)) {
5194             __skb_unlink(skb, &sk->sk_receive_queue);
5195             __kfree_skb(skb);   // wzj(a)
5196         }
5197     }
5198
5199     tp->urg_data = TCP_URG_NOTYET;
5200     tp->urg_seq = ptr;

It compares tp->copied_seq with tp->urg_seq.
And I found only 1 assignment of tp->urg_seq in the code base,
which is after the if-statement in the same tcp_check_urg() function.

So it seems tp->urg_seq is not assigned to any sequence number before
its first use.
Is that correct?

P.S. In our symbolic execution tool, we found an execution path that
requires the client initial sequence number (ISN) to be 0xFF FF FF FF.
And when it traverse that path, the tp->copied_seq is equal to (client
ISN + 1), and compared with 0 in this if-statatement.
Therefore the client ISN has to be exactly 0xFF FF FF FF to hit this
execution path.

To trigger this, we first sent a SYN packet, and then an ACK packet
with urgent pointer.

Best Regards,
Zhongjie Wang
Ph.D. Candidate 2015 Fall
Department of Computer Science & Engineering
University of California, Riverside

Zhongjie Wang
Ph.D. Candidate 2015 Fall
Department of Computer Science & Engineering
University of California, Riverside



On Mon, Jun 10, 2019 at 5:00 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Sun, Jun 9, 2019 at 11:12 PM Zhongjie Wang <zwang048@ucr.edu> wrote:
> ...
> > It compares tp->copied_seq with tcp->rcv_nxt.
> > However, tp->copied_seq is only assigned to an appropriate sequence number when
> > it copies data to user space. So here tp->copied_seq could be equal to 0,
> > which is its initial value, if no data are copied yet.
>
> I don't believe that's the case. As far as I can see, the
> tp->copied_seq field is initialized to tp->rcv_nxt in the various
> places where TCP connections are initialized:
>
>   tp->copied_seq = tp->rcv_nxt;
>
> > In this case, the condition becomes 0 != tp->rcv_nxt,
> > and it renders this comparison ineffective.
> >
> > For example, if we send a SYN packet with initial sequence number 0xFF FF FF FF,
> > and after receiving SYN/ACK response, then send a ACK packet with sequence
> > number 0, it will bypass this if-then block.
> >
> > We are not sure how this would affect the TCP logic. Could you please confirm
> > that tp->copied_seq should be assigned to a sequence number before its use?
>
> Yes, the tp->copied_seq  ought to be assigned to a sequence number
> before its use, and AFAICT it is. Can you identify a specific sequence
> of code execution (and ideally construct a packetdrill script) where
> tp->copied_seq is somehow read before it is initialized?
>
> cheers,
> neal
