Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C72B3C46D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403864AbfFKGqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:46:19 -0400
Received: from mx6.ucr.edu ([138.23.62.71]:13526 "EHLO mx6.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390485AbfFKGqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 02:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1560235580; x=1591771580;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=vhK+lK9e1q+91pn/QnbCltunFi0pGuaDmVBqbv68svU=;
  b=d8n5QGSzEIIgW51sHpsk3Enpiwbw3fAjBV/yPUql326+Vu6mKIaGYXux
   Z4YsPZT25Ih6jCn1AmsOotV7Ov8IdX3AkkYin33u1dnUNqDNcM2iUc4Gi
   Z8GSGo8vcZqlGDHCkAbWhJ/CT1SFzBCE9K6UefvusQbS/yPDpRoCV6vRU
   QehGpGU+rWl4Xu6zz2qv81Vq1HUXgONGj7BEw2Ensrp0zaD6SRBdK6rAX
   ZCr/RxRAD0e8Sv729lfJVrrL4uNBDWaIoHys5HRO1zwopLkTjUpOIsgMj
   N+2uQ33262vSML7dX94lFCUx/iqZujP3Gk9MHWCC/DsHJ2dNOYYIswSeU
   Q==;
IronPort-PHdr: =?us-ascii?q?9a23=3AIkbAVxYXUX3b1emL49vv9qj/LSx+4OfEezUN459i?=
 =?us-ascii?q?sYplN5qZoMS7bnLW6fgltlLVR4KTs6sC17OP9fm9AidZucnJmUtBWaQEbwUCh8?=
 =?us-ascii?q?QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFRrlKAV6?=
 =?us-ascii?q?OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQi6oR/MusQWj4ZuJbs9xgfLr3BVZ+?=
 =?us-ascii?q?lY2GRkKE6JkR3h/Mmw5plj8ypRu/Il6cFNVLjxcro7Q7JFEjkoKng568L3uxbN?=
 =?us-ascii?q?SwuP/WYcXX4NkhVUGQjF7Qr1UYn3vyDnq+dywiiaPcnxTbApRTSv6rpgRRH0hC?=
 =?us-ascii?q?sbMTMy7XragdJsgq1FvB2hpgR/w4/Kb4GTKPp+Zb7WcdcDSWZcQspdSylND4Wh?=
 =?us-ascii?q?ZIUNEuUBJ/5VoIbzp1QMrRWwCwqiCv7xxDBUnXL2wbE23v49HQ3awAAtHdQDu2?=
 =?us-ascii?q?nUotXvM6cSVPi4w6rIzTXEafNW1jX96InWfRs8of6DR7RwccXMwkQoFgLEgE+f?=
 =?us-ascii?q?qYrqPz+J2ekAsHOW7/d8WuK1kWIotRx+oiW2y8oql4LHhZoVx0ja+SllxIs5P9?=
 =?us-ascii?q?61RU5hbdK6DZdduDuWO5VqTs8+RWxjpTw0xaccuZGheSgH0JEnxxnCZPOZa4WI?=
 =?us-ascii?q?+RfjVPqJITd/mXJlZKqzhxas/kikze3xTsy030xLripBi9XMrnQN2wHK5siJVP?=
 =?us-ascii?q?dx4lut1SyA1wDU7eFELkQ0mrTBJ5E9xb4wk4IfsUXFHiDohEX7lLGaelkg9+Sy?=
 =?us-ascii?q?6OnqYq/qqoGBO4J7kA3yLLgiltCnDeQ9KAcOXmyb+eqm1L3k+E30WLRLj/Msna?=
 =?us-ascii?q?nfv5DWOcsWq62iDg9Izokj8QyzACm739QFhXUHNk5KeAqbj4j1PFHDOPb4Aumj?=
 =?us-ascii?q?g1uxjjhr2evLPqPuAprTNHjPirThcqhn605a1gUzycpT55VOCrEOc7rPXRrXud?=
 =?us-ascii?q?XcRjQwKQCrzuLjQIF73YoEVX2CBquxP6TVvluFoOkoJr/fSpUSvWPPK/8j6Pzv?=
 =?us-ascii?q?gDcGkFkSNf27wpIRZyjkTtx7KF/fbHbx1IRSWVwWtxYzGbS5wGaJViReMjPrB/?=
 =?us-ascii?q?ox?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DFAgBhTf9cdcjWVdFmg36CGCiEFZUAm?=
 =?us-ascii?q?HWBEANUAQgBAQEOLwEBhEACgncjOBMBAwEBBQEBAQEEARMBCg0KBycxgjopAYJ?=
 =?us-ascii?q?nAQUjBFIQCwsDCgICJgICIhIBBQEcBhMIhSUFnHM8iyB+M4hjAQcKgUYSeiiLX?=
 =?us-ascii?q?YIWhCM+hBEBEgGDKYJYBIEtAQEBkxmUYQEGAgGBfxOLGogpG4Ilh26DE4l2LaM?=
 =?us-ascii?q?9DyGBRVgwcTMaJX8GZ4FOghsXgQIBCAONMiIwjT2CQwEB?=
X-IPAS-Result: =?us-ascii?q?A2DFAgBhTf9cdcjWVdFmg36CGCiEFZUAmHWBEANUAQgBAQE?=
 =?us-ascii?q?OLwEBhEACgncjOBMBAwEBBQEBAQEEARMBCg0KBycxgjopAYJnAQUjBFIQCwsDC?=
 =?us-ascii?q?gICJgICIhIBBQEcBhMIhSUFnHM8iyB+M4hjAQcKgUYSeiiLXYIWhCM+hBEBEgG?=
 =?us-ascii?q?DKYJYBIEtAQEBkxmUYQEGAgGBfxOLGogpG4Ilh26DE4l2LaM9DyGBRVgwcTMaJ?=
 =?us-ascii?q?X8GZ4FOghsXgQIBCAONMiIwjT2CQwEB?=
X-IronPort-AV: E=Sophos;i="5.63,578,1557212400"; 
   d="scan'208";a="58721142"
Received: from mail-pl1-f200.google.com ([209.85.214.200])
  by smtpmx6.ucr.edu with ESMTP/TLS/AES128-GCM-SHA256; 10 Jun 2019 23:46:19 -0700
Received: by mail-pl1-f200.google.com with SMTP id i3so7195433plb.8
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 23:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXSHHsIC6RHwpwZphTAKvWmCX96POzDYvfIDZ/eXDjM=;
        b=Z5YSY762BRlDZkvK6GdzpAd02xJq+f3h8uoWaY/rMqaGRS6unJssHA5TL1cloUXT3x
         59Xlj3JXVlgJq1YF2aZWjORJ1kj2qdRx/TUVztHiZYtr3WPOxGvXTT/u59fAdUE8NFmc
         QsiHlKN49DcsPO8D9rY5GZ1MrhPsrOUwajdiSyljxBYn9yHgPt8w6m0lR4dubZBN0hEY
         VOYchUfHnR+8qfO9LlbNbtGzEMfd349kcNTQnSUa1ecQNY0iGmxIx/bXSXgvdDylbJx1
         mQBTKrew/eM62yHS/MBy238ulYM9DGvDmlxvDetZvjvqWTJs2TSlsPs/Y3EmxWSHxiy8
         EmDQ==
X-Gm-Message-State: APjAAAW+ZCAgZKlkiJELmDyD960Wy/1NKGZBGiZORCC2VK3eeK9zEidZ
        YTgaaAxoyZO33ljozWBd9nF5X3jU2yJoXmLSeylXEZ8tExEiYiVUgX8JNPMR5mOVeXY7GI0eoy/
        p8w9xB9/xj75OLrjihZS6+O/UfapmOnvPNg==
X-Received: by 2002:a63:5207:: with SMTP id g7mr18398789pgb.356.1560235577833;
        Mon, 10 Jun 2019 23:46:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMVSh/1HQl0dBczN7Td0hgnhXhHeFfs6pq9zJSXfrif0rCjZ4JElYSErMjOyFXyKoay5PzIGsBBrhpQPMso20=
X-Received: by 2002:a63:5207:: with SMTP id g7mr18398776pgb.356.1560235577391;
 Mon, 10 Jun 2019 23:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
 <CADVnQymPcJJ-TnsNkZm-r+PrhxHjPLLLiDhf3GjeBjSTGJwbkw@mail.gmail.com>
 <CAHx7fy5bSghKONyYSW-4oXbEKLHUxYC7vE=ZiKLXUED-iuuCdw@mail.gmail.com> <CADVnQy=P=P1iPxrgqQ1U5xwY7Wj3H54XF1sfTyi92mQkLgjb6g@mail.gmail.com>
In-Reply-To: <CADVnQy=P=P1iPxrgqQ1U5xwY7Wj3H54XF1sfTyi92mQkLgjb6g@mail.gmail.com>
From:   Zhongjie Wang <zwang048@ucr.edu>
Date:   Mon, 10 Jun 2019 23:45:39 -0700
Message-ID: <CAHx7fy68uTURceZtzYEnvdZ1pD2_F0dNJKjB7c7JTT8pjNKRSw@mail.gmail.com>
Subject: Re: tp->copied_seq used before assignment in tcp_check_urg
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neal,

Thanks for your valuable feedback! Yes, I think you are right.
It seems not a problem if tp->urg_data and tp->urg_seq are used together.
From our test results, we can only see there are some paths requiring
specific initial sequence number to reach.
But as you said, it would not cause a difference in the code logic.
We haven't observed any abnormal states.

Thanks,
Zhongjie Wang
Ph.D. Candidate 2015 Fall
Department of Computer Science & Engineering
University of California, Riverside


On Mon, Jun 10, 2019 at 7:19 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Mon, Jun 10, 2019 at 7:48 PM Zhongjie Wang <zwang048@ucr.edu> wrote:
> >
> > Hi Neal,
> >
> > Thanks for your reply. Sorry, I made a mistake in my previous email.
> > After I double checked the source code, I think it should be tp->urg_seq,
> > which is used before assignment, instead of tp->copied_seq.
> > Still in the same if-statement:
> >
> > 5189     if (tp->urg_seq == tp->copied_seq && tp->urg_data &&
> > 5190         !sock_flag(sk, SOCK_URGINLINE) && tp->copied_seq != tp->rcv_nxt) {
> > 5191         struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
> > 5192         tp->copied_seq++;
> > 5193         if (skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq)) {
> > 5194             __skb_unlink(skb, &sk->sk_receive_queue);
> > 5195             __kfree_skb(skb);   // wzj(a)
> > 5196         }
> > 5197     }
> > 5198
> > 5199     tp->urg_data = TCP_URG_NOTYET;
> > 5200     tp->urg_seq = ptr;
> >
> > It compares tp->copied_seq with tp->urg_seq.
> > And I found only 1 assignment of tp->urg_seq in the code base,
> > which is after the if-statement in the same tcp_check_urg() function.
> >
> > So it seems tp->urg_seq is not assigned to any sequence number before
> > its first use.
> > Is that correct?
>
> I agree, it does seem that tp->urg_seq is not assigned to any sequence
> number before its first use.
>
> AFAICT from a quick read of the code, this does not matter. It seems
> the idea is for tp->urg_data and tp->urg_seq to be set and used
> together, so that tp->urg_seq is never relied upon to be set to
> something meaningful unless tp->urg_data has also been verified to be
> set to something (something non-zero).
>
> I suppose it might be more clear to structure the code to check urg_data first:
>
>   if (tp->urg_data && tp->urg_seq == tp->copied_seq &&
>
> ...but in practice AFAICT it does not make a difference, since no
> matter which order the expressions use, both conditions must be true
> for the code to have any side effects.
>
> > P.S. In our symbolic execution tool, we found an execution path that
> > requires the client initial sequence number (ISN) to be 0xFF FF FF FF.
> > And when it traverse that path, the tp->copied_seq is equal to (client
> > ISN + 1), and compared with 0 in this if-statatement.
> > Therefore the client ISN has to be exactly 0xFF FF FF FF to hit this
> > execution path.
> >
> > To trigger this, we first sent a SYN packet, and then an ACK packet
> > with urgent pointer.
>
> Does your test show any invalid behavior by the TCP endpoint? For
> example, does the state in tcp_sock become incorrect, or is some
> system call return value or outgoing packet incorrect? AFAICT from the
> scenario you describe it seems that the "if" condition would fail when
> the receiver processes the ACK packet with urgent pointer, because
> tp->urg_data was not yet set at this point. Thus it would seem that in
> this case it does not matter that tp->urg_seq is not assigned to any
> sequence number before being first used.
>
> cheers,
> neal
