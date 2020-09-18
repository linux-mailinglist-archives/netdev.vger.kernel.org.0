Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4F626FF69
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgIROAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIROAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:00:21 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64922C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 07:00:21 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id h9so1441077ooo.10
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 07:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jNMd51wVvA3B22ClH5kJlhJw5mkneCkBS37T7H4sLTE=;
        b=AWcLbVyKLbqQhD5JbcZre59JgrCITaNj/yblTODHUC+QZs3y4Y03yY1dhZv66HGyUi
         HtWSf+b87SczlLWIAMSUPcCVBhvG4212yFXftsA0RO636V8mwHSmkZd8B2No1HqE6Qnl
         vA0vDAUbtE4673BtAWAtej1twRyZG9UtBKKzrCuO3okgqESUOhkLOOUOsKC8Bn9r7oUm
         54gvkjT9UCMJImanTdsp7zOVMIqGfBPdp3ME25XxTwx4JkMxQDX9HYZ8bpMyzGh1oazM
         mxu1/P+R5+duwQzlQZ0RDQjx89Vv79nqvnCsfPs/ymuJ6u9hy7xF8wIjapaXtNun4MII
         VhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jNMd51wVvA3B22ClH5kJlhJw5mkneCkBS37T7H4sLTE=;
        b=krc30PWhW3FJfckgLEKHSU7jRdJMa1urbkS3vlmU/DplQOWZAosfjdOwiaQv8OXv4P
         UhV/yjxq+kQvHVeLO+NT1Ho8agqs9MAglcZfUZtvpqtqqQ9RpC2G9V5BWhfzNaoxXUKn
         zIHURVqut/qGVWSx7hkUvAprMVPHnFhonPjw04vAdyb4Is2bVflLryV1uoIInLzmrsQR
         SCtZ97dsNWYleZfkcRjmI7Lb0v9MmSqJHfrkxqWf0PE2XiZ/R33saAfBdNRnFxuxmUj2
         aY6i8BZ1k1i8CVb87/nL8Ugu6FfXQhd5HDhqgd21Wd6E7lD+PAE07lAY97sfdVvot1NQ
         9qTw==
X-Gm-Message-State: AOAM531cRDkFnz7J/wHRDwx2F43Tay+g8Mb+8PGaQdNxKMKqzccRNuO9
        broxAujmQlOJBH7QxYCY1rNOh8RlD7iMwQaR9lZjmTqJ472iHg==
X-Google-Smtp-Source: ABdhPJxeF4lCjG5nKWW1OVV33m8h52HtBgoWNQCwBgCuIRmmnNUFvEu6egRaNZ8OZqx0F+PTBTeTmYKhde13rux4JQQ=
X-Received: by 2002:a4a:988c:: with SMTP id a12mr24364301ooj.46.1600437620318;
 Fri, 18 Sep 2020 07:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAH+fs=8Fq5_E4aooa+bJoWCgQn1-7g9Y9rpBdGAH7ssGMkZUnA@mail.gmail.com>
 <CAH+fs=-d=RUAgbCSn-OasVwVERVMP+v-Y0vvU7Y74p8c8TihCw@mail.gmail.com>
In-Reply-To: <CAH+fs=-d=RUAgbCSn-OasVwVERVMP+v-Y0vvU7Y74p8c8TihCw@mail.gmail.com>
From:   Marc Leeman <marc.leeman@gmail.com>
Date:   Fri, 18 Sep 2020 16:00:19 +0200
Message-ID: <CAH+fs=98ciuu69im1tSMszBjv9a9MT1Pmw4QdBig9MeQtKwybQ@mail.gmail.com>
Subject: Re: (pch_gbe): transmit queue 0 timed out
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> we started reproducing the problem by flooding the NIC with multicast
> packets in a directly connected setup (no switch, just device and test
> device with a single cable). At some point, the driver stops receiving
> packets; but we've noticed that the link level leds are dead too.

After some more testing the problem seems to occur more often when
subscribing and unsubscribing from multicast addresses (I don't know
if the number of userspace listeners have a real impact at the
moment). We do not seem to have the issue when running the GNU/Debian
stretch kernel (4.9.228) while we do see it when running a GNU/Debian
buster kernel (4.19.132). Having a look at the relevant changes; I'm
wondering if the patches of Paul Burton could have something to do
with this, from a quick glance, these are the ones that state that
changes have been made in the multicast behaviour.

> Reloading the driver does not re-establish the link (no-carrier), only
> a reboot when the CPU comes out of reset does.

I have not yet checked if this is related with the previous: in normal
circumstances there is little need to unload/load the normal kernel
module and this is not a normal operational situation.

g. Marc
