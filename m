Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3593A224AF5
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgGRLa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgGRLa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:30:26 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BFBC0619D2;
        Sat, 18 Jul 2020 04:30:25 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so13512980ejb.11;
        Sat, 18 Jul 2020 04:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XrBiEFayT15OrTXBdIxofeFQ096MXdYhDGFXo9ZUR40=;
        b=HAlBMolmd+6ohPZsXPHQWx2erigm8H9J0zgNVXfqgYRnsx96fqXcELDRh+X3yCQSZO
         l6iBATlWRPOYf6YzvxUsmMNACfUR6FrUGjsi3Wb3YNlPfaDray6JXt0hIA3ko2N99OkF
         Z5yD38pU0DxNsYVqy9y3Gnvgmy1mGbp+4TQAwJRSiBw5lzMU/nEyfzIJO2A9KQ9UFDEF
         kEYMf9eIprj1XXToAKeRC050I/3dOFo6BOUpeKJwrLhWaw/x+igXXdvMZgPcYhJvnGgv
         MQiOtmDDa28uTv4YbRIlQn0GKKzfyPrCleeTeSW8WJ5SuymsgJJCODkRqzlPiumQuFn5
         jNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XrBiEFayT15OrTXBdIxofeFQ096MXdYhDGFXo9ZUR40=;
        b=KoeJ8rIjKYfVqyUC1KJCrf4a4+AG68ZNO3082zp2E6u1EP4+icSjAtnQ25oS4nI5f0
         ponbmKGehdlppRkywl+4ZEYQKxhrMy46qTErCdiRy9WrauvM8K8J7qyLwL7XZRaLs+Vk
         ub1LSi6t0rzE7ZdMe0dA7mZRCfcu5/C1Cmm7qrk0PwNDJocQgd2d5L5zUETTk13AxfDP
         BRaWQ44NOy5XhvZp2AZUGkUdsoLiF7mQMNVC9fnm6ZNW3ECnlxay0k5U+MEJpkrDVWtd
         Vq/5FwMnr+tkVVUERSpALe3xL8/njuz5XlC6IBJOltkyZOjT1g298iZxCwys01WpvIYS
         fJCQ==
X-Gm-Message-State: AOAM531ZQK+PN01nEdiJXnTLj/A7uty4Xkq9JThl7HY8gikR7ub8D7ZV
        kI3jYKmP2hl89YCHEoe3ldU=
X-Google-Smtp-Source: ABdhPJyH1ON74dAxMmHZvAloRcLh3upalmYRmKMoNoN7BIgmJk5KMqNWV3Q2VNz1cL5xz61tL5Gldg==
X-Received: by 2002:a17:906:3784:: with SMTP id n4mr13009019ejc.277.1595071824098;
        Sat, 18 Jul 2020 04:30:24 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id t20sm10416917ejd.124.2020.07.18.04.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 04:30:23 -0700 (PDT)
Date:   Sat, 18 Jul 2020 14:30:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
Message-ID: <20200718113021.tcdfoatsqffr45f2@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <87imelj14p.fsf@osv.gnss.ru>
 <20200717215719.nhuaak2xu4fwebqp@skbuf>
 <878sfh2iwc.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sfh2iwc.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 01:54:11PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > On Sat, Jul 18, 2020 at 12:13:42AM +0300, Sergey Organov wrote:
> >> Vladimir Oltean <olteanv@gmail.com> writes:
> >>
> >> > I've tried to collect and summarize the conclusions of these discussions:
> >> > https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
> >> > https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
> >> > which were a bit surprising to me. Make sure they are present in the
> >> > documentation.
> >>
> >> As one of participants of these discussions, I'm afraid I incline to
> >> alternative approach to solving the issues current design has than the one
> >> you advocate in these patch series.
> >>
> >> I believe its upper-level that should enforce common policies like
> >> handling hw time stamping at outermost capable device, not random MAC
> >> driver out there.
> >>
> >> I'd argue that it's then upper-level that should check PHY features, and
> >> then do not bother MAC with ioctl() requests that MAC should not handle
> >> in given configuration. This way, the checks for phy_has_hwtstamp()
> >> won't be spread over multiple MAC drivers and will happily sit in the
> >> upper-level ioctl() handler.
> >>
> >> In other words, I mean that it's approach taken in ethtool that I tend
> >> to consider being the right one.
> >>
> >> Thanks,
> >> -- Sergey
> >
> > Concretely speaking, what are you going to do for
> > skb_defer_tx_timestamp() and skb_defer_rx_timestamp()? Not to mention
> > subtle bugs like SKBTX_IN_PROGRESS.
>
> I think that we have at least 2 problems here, and what I argue about
> above addresses one of them, while you try to get solution for another
> one.
>
> > If you don't address those, it's pointless to move the
> > phy_has_hwtstamp() check to net/core/dev_ioctl.c.
>
> No, even though solving one problem could be considered pointless
> without solving another, it doesn't mean that solving it is pointless. I
> do hope you will solve another one.
>
> I believe that logic in ethtool ioctl handling should be moved to clocks
> subsystem ioctl handling, and then ethtool should simply forward
> relevant calls to clocks subsystem. This will give us single
> implementation point that defines which ioctls go to which clocks, and
> single point where policy decisions are made, that, besides getting rid
> of current inconsistencies, will allow for easier changes of policies in
> the future.
>
> That also could be the point that caches time stamping configuration and
> gives it back to user space by ioctl request, freeing each driver from
> implementing it, along with copying request structures to/from user
> space that currently is done in every driver.
>
> I believe such changes are valuable despite particular way the
> SKBTX_IN_PROGRESS issue will be resolved.
>
> > The only way I see to fix the bug is to introduce a new netdev flag,
> > NETIF_F_PHY_HWTSTAMP or something like that. Then I'd grep for all
> > occurrences of phy_has_hwtstamp() in the kernel (which currently amount
> > to a whopping 2 users, 3 with your FEC "fix"), and declare this
> > netdevice flag in their list of features. Then, phy_has_hwtstamp() and
> > phy_has_tsinfo() and what not can be moved to generic places (or at
> > least, I think they can), and those places could proceed to advertise
> > and enable PHY timestamping only if the MAC declared itself ready. But,
> > it is a bit strange to introduce a netdev flag just to fix a bug, I
> > think.
>
> To me this sounds like a plan.
>
> In general (please don't take it as direct proposal to fix current
> issues), the most flexible solution would be to allow for user space to
> select which units will be time stamping (kernel clock being simply one
> of them), and to deliver all the time stamps to the user space. This
> will need clock IDs to be delivered along with time stamps (that is a
> nice thing to have by itself, as I already mentioned elsewhere in
> previous discussions.) For now it's just a raw idea, nevertheless to me
> it sounds like a suitable goal for future design.
>
> Thanks,
> -- Sergey

To me, there's one big inconsistency I see between your position when
you were coming from a 4.9 kernel where you wanted to fix a bug, and
your position now.

Your position when _you_ wanted to solve a problem for yourself was:

  |You see, I have a problem on kernel 4.9.146. After I apply this patch,
  |the problem goes away, at least for FEC/PHY combo that I care about, and
  |chances are high that for DSA as well, according to your own expertise.
  |Why should I care what is or is not ready for what to get a bug-fix
  |patch into the kernel? Why should I guess some vague "intentions" or
  |spend my time elsewhere?

As I said in that email thread, I can't contradict you. It is a design
limitation which right now I am simply documenting. That design
limitation is there to stay in stable kernels: I don't think there is
any way to backport a new flag to netdev_features_t to kernels as old as
4.9 and such. If you think there is, please say so, that would change
things quite a lot.

And now, you're arguing that I shouldn't be documenting the design
limitation, I should be fixing it. Maybe I will, but first of all,
you're asking me to effectively close the door for anybody else in your
position. On one side you proved that PHY timestamping is something that
should have been working, and now you're treating it as something which
shouldn't be.

You can argue that we can keep accepting bug fixes to this problem for
stable kernels, and in that case I don't see why you're arguing that we
shouldn't be documenting the design limitation.

Nobody said things are set in stone, I'm simply recording where we are
today and I'll be making further changes to the documentation as things
progress.

Thanks,
-Vladimir
