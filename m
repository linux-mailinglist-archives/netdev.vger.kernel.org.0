Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E25224B98
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGRNf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgGRNf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:35:28 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9BBC0619D2;
        Sat, 18 Jul 2020 06:35:27 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id j11so15691209ljo.7;
        Sat, 18 Jul 2020 06:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=cszaczazX+nza/wuzwl5vFGOp/ocDHkvRzppDicZINg=;
        b=umGNSCOfa1EgC0PV9yb2k+sT9qPCDGtVhOG+V/6Grnax89npRY3MGPdkKcDRUxAnXG
         4EtLb01hWlJpYpnstc51fv72o8J35yC5SLvuCD1pBTM/AIMAghtE+4Ka6REeK0Jyqj4/
         ZyLkP0ng9u5AVBXZc80+enMJXZ/WS/Cu4Q+W3TW6w44q2vATKQ1dft8MYSnktwM3Txvn
         2HB7vHxSOD0vSfi1w+Wi3LcZlJSqmdqFotXZ4BGQnsNyzOn/gkKDy+0IfBw8yEMHJM5E
         Uz5AAjmydeFTfnWHT+bolAfZZS604LtH8g16IstkS7GGdlac1DGkfG9b/K5lkTNwZdQh
         MxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=cszaczazX+nza/wuzwl5vFGOp/ocDHkvRzppDicZINg=;
        b=J26VN9aySmslsRnnRlLKUcpt2gTVIfTWfwb+/gW74qxKqC7XiPSN/iBCnz6MAPDBDp
         NxsOrq14rYQoCCVN8nh6nvFGc51WQQQmRdLCXcxgd7LoBVCTf233Gq2CQ8r5dqXfraLz
         dhGtWqUhzvekO6VSme4663s2wsGAijrIqcWcTSbOs7LjdKfcOOpzWePWHhPVhL6mE2Vc
         jSEUww3P3xtMiU5BITL9C8fyw1MjCongrxmKQ/vnSPa3MPZJq+66czVY36+41a2HPh6H
         AdiLVe6qCApohqmCKShF4x3bx2+03lL7pFc8IgfBoUBfpkwn0W18Zz/CXUCb2OgMw7vQ
         KjDg==
X-Gm-Message-State: AOAM531g57vDTFI/39uyUy70W6tA0i+8H5yi0o/eEYdpDgHQMGg0J2PK
        YnFWT0434DqTTzg2zRnQFz7cn4Sl
X-Google-Smtp-Source: ABdhPJxlxDE5ruuGyNxobUU/DmGKhkLVkvU5PXpWt8zExf5gnmweM8dq5/weDBQn4cXCWYGtAHQuQg==
X-Received: by 2002:a2e:3304:: with SMTP id d4mr5876780ljc.115.1595079325671;
        Sat, 18 Jul 2020 06:35:25 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id w19sm2207131ljh.106.2020.07.18.06.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 06:35:24 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
References: <20200717161027.1408240-1-olteanv@gmail.com>
        <87imelj14p.fsf@osv.gnss.ru> <20200717215719.nhuaak2xu4fwebqp@skbuf>
        <878sfh2iwc.fsf@osv.gnss.ru> <20200718113021.tcdfoatsqffr45f2@skbuf>
Date:   Sat, 18 Jul 2020 16:35:23 +0300
In-Reply-To: <20200718113021.tcdfoatsqffr45f2@skbuf> (Vladimir Oltean's
        message of "Sat, 18 Jul 2020 14:30:21 +0300")
Message-ID: <871rl90wv8.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Sat, Jul 18, 2020 at 01:54:11PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>>
>> > On Sat, Jul 18, 2020 at 12:13:42AM +0300, Sergey Organov wrote:
>> >> Vladimir Oltean <olteanv@gmail.com> writes:
>> >>
>> >> > I've tried to collect and summarize the conclusions of these
>> >> > discussions:
>> >> > https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
>> >> > https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
>> >> > which were a bit surprising to me. Make sure they are present in the
>> >> > documentation.
>> >>
>> >> As one of participants of these discussions, I'm afraid I incline to
>> >> alternative approach to solving the issues current design has than the one
>> >> you advocate in these patch series.
>> >>
>> >> I believe its upper-level that should enforce common policies like
>> >> handling hw time stamping at outermost capable device, not random MAC
>> >> driver out there.
>> >>
>> >> I'd argue that it's then upper-level that should check PHY features, and
>> >> then do not bother MAC with ioctl() requests that MAC should not handle
>> >> in given configuration. This way, the checks for phy_has_hwtstamp()
>> >> won't be spread over multiple MAC drivers and will happily sit in the
>> >> upper-level ioctl() handler.
>> >>
>> >> In other words, I mean that it's approach taken in ethtool that I tend
>> >> to consider being the right one.
>> >>
>> >> Thanks,
>> >> -- Sergey
>> >
>> > Concretely speaking, what are you going to do for
>> > skb_defer_tx_timestamp() and skb_defer_rx_timestamp()? Not to mention
>> > subtle bugs like SKBTX_IN_PROGRESS.
>>
>> I think that we have at least 2 problems here, and what I argue about
>> above addresses one of them, while you try to get solution for another
>> one.
>>
>> > If you don't address those, it's pointless to move the
>> > phy_has_hwtstamp() check to net/core/dev_ioctl.c.
>>
>> No, even though solving one problem could be considered pointless
>> without solving another, it doesn't mean that solving it is pointless. I
>> do hope you will solve another one.
>>
>> I believe that logic in ethtool ioctl handling should be moved to clocks
>> subsystem ioctl handling, and then ethtool should simply forward
>> relevant calls to clocks subsystem. This will give us single
>> implementation point that defines which ioctls go to which clocks, and
>> single point where policy decisions are made, that, besides getting rid
>> of current inconsistencies, will allow for easier changes of policies in
>> the future.
>>
>> That also could be the point that caches time stamping configuration and
>> gives it back to user space by ioctl request, freeing each driver from
>> implementing it, along with copying request structures to/from user
>> space that currently is done in every driver.
>>
>> I believe such changes are valuable despite particular way the
>> SKBTX_IN_PROGRESS issue will be resolved.
>>
>> > The only way I see to fix the bug is to introduce a new netdev flag,
>> > NETIF_F_PHY_HWTSTAMP or something like that. Then I'd grep for all
>> > occurrences of phy_has_hwtstamp() in the kernel (which currently amount
>> > to a whopping 2 users, 3 with your FEC "fix"), and declare this
>> > netdevice flag in their list of features. Then, phy_has_hwtstamp() and
>> > phy_has_tsinfo() and what not can be moved to generic places (or at
>> > least, I think they can), and those places could proceed to advertise
>> > and enable PHY timestamping only if the MAC declared itself ready. But,
>> > it is a bit strange to introduce a netdev flag just to fix a bug, I
>> > think.
>>
>> To me this sounds like a plan.
>>
>> In general (please don't take it as direct proposal to fix current
>> issues), the most flexible solution would be to allow for user space to
>> select which units will be time stamping (kernel clock being simply one
>> of them), and to deliver all the time stamps to the user space. This
>> will need clock IDs to be delivered along with time stamps (that is a
>> nice thing to have by itself, as I already mentioned elsewhere in
>> previous discussions.) For now it's just a raw idea, nevertheless to me
>> it sounds like a suitable goal for future design.
>>
>> Thanks,
>> -- Sergey
>
> To me, there's one big inconsistency I see between your position when
> you were coming from a 4.9 kernel where you wanted to fix a bug, and
> your position now.

[First of all, as it seems there is misunderstanding here, let me say
right from beginning that I have nothing against documenting current
status, I'm rather all in favor of it, and I do appreciate your work on
it very much, and I believe I already said this in a reply to your
previous documentation patch some time ago.]

Inconsistency? I don't think so. One thing is to fix a bug within
current design limitations, and another one -- suggest design
improvements that should make things better in the future. I just talk
about different matters.

>
> Your position when _you_ wanted to solve a problem for yourself was:
>
>   |You see, I have a problem on kernel 4.9.146. After I apply this patch,
>   |the problem goes away, at least for FEC/PHY combo that I care about, and
>   |chances are high that for DSA as well, according to your own expertise.
>   |Why should I care what is or is not ready for what to get a bug-fix
>   |patch into the kernel? Why should I guess some vague "intentions" or
>   |spend my time elsewhere?
>
> As I said in that email thread, I can't contradict you.

I fail to see what this has to do with current discussion. Apparently
I was not able to make my current intentions clear enough, but I try
again below.

> It is a design limitation which right now I am simply documenting.
> That design limitation is there to stay in stable kernels: I don't
> think there is any way to backport a new flag to netdev_features_t to
> kernels as old as 4.9 and such. If you think there is, please say so,
> that would change things quite a lot.

I didn't even think about it, sorry, don't know how you figured I have
an opinion about it.

> And now, you're arguing that I shouldn't be documenting the design
> limitation, I should be fixing it.

No, I'm not. In case you just document them, no. If you also suggest
some road for improvements that I don't agree on, only then I argue.

> Maybe I will, but first of all, you're asking me to effectively close
> the door for anybody else in your position. On one side you proved
> that PHY timestamping is something that should have been working, and
> now you're treating it as something which shouldn't be.

I'm not asking you for anything, no. I just shared my thoughts on the
issue of proper ways to improve overall design. You are free to disagree
or even to ignore them.

> You can argue that we can keep accepting bug fixes to this problem for
> stable kernels, and in that case I don't see why you're arguing that we
> shouldn't be documenting the design limitation.

You don't see because I'm not. I'm all for documenting.

I just got an impression that you also suggest ways to improve the
design, and, based on your comment that ethtool way is the bad design as
it doesn't consult MAC when handling ioctls, I was afraid the design
might went into direction I don't agree with.

Maybe I got your intentions wrong. Sorry if I did.

>
> Nobody said things are set in stone, I'm simply recording where we are
> today and I'll be making further changes to the documentation as things
> progress.

I have absolutely nothing against documenting current status, not at
all. Moreover, as I think I already said in this thread, your recent
idea about NETIF_F_PHY_HWTSTAMP seemed sound to me too.

I'm sorry I managed to provoke so much worry on your side!

Thanks,
-- Sergey
