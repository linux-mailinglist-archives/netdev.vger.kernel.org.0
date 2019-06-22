Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B904F3E3
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 07:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfFVFgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 01:36:20 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:40056 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfFVFgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 01:36:20 -0400
Received: by mail-lj1-f174.google.com with SMTP id a21so7788084ljh.7
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 22:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=acDGavsv+ifpDNzWCcEhjWjA5mBlJO3plfymnjZRfNs=;
        b=dS5T3+7C4pF3gau9qTu/iefZDi1XDNRzah4/GgUuE//TX37Nuo4NA+ux/SDCemgRdv
         OEXVvYEWSbtntmd85CyF2jE/sG2nJ7QNU9zCy9FWV7YaJnsboe8m46r5/JENLynhdtVw
         rVWwqWw9rWJCe75ubH1RRODEbCl+uM2asliTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=acDGavsv+ifpDNzWCcEhjWjA5mBlJO3plfymnjZRfNs=;
        b=TEPRxDBWA3T/kfyOZ3obpCby516HFDgTeJ03CNeqNWCut6yIqcbGSJst1Tpi+3gk6F
         GNwg7e6v3DuocwxuFPfk/LNQN0kXjbqVPcH9yeQkRb7z+Swy4QPvtCaUKsD+Ap93IZF4
         eKSb0hpt/TrwqW44vLyC+IYHYnTn07ZYuExfZWh1oTc97Pw+FNUg/jQah+Gh1F4s8AIQ
         FRcwjAT9PCBFT7EV1okf5RYQ9rCqGbffVJJcnRI0fZRlkhsL6mOP2qAV6/uOrKg1Qmyr
         SXFXQDn9CZUPVmpkqsGJqDX/7MDkTCMbL6aArx+t0BjVOFeJy2sA/upMCHkjdcCCX+Ez
         5f8w==
X-Gm-Message-State: APjAAAWohkRQlSrTIxAVlcNM+Qng3YHYIQCGeHS4UrYv+Yz750y2RbNF
        oP7jvqfjAlid3z8aON8VhUHVzrvoch0=
X-Google-Smtp-Source: APXvYqyPcR4s2NNmnChnXZCZKvW1e+50f3hTh30t8MiPga3Q8Qw7H6ZIN6epeZPIPxrGca+uuaSQcw==
X-Received: by 2002:a2e:968e:: with SMTP id q14mr31984686lji.195.1561181777863;
        Fri, 21 Jun 2019 22:36:17 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id p27sm659458lfo.16.2019.06.21.22.36.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 22:36:17 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id i21so7806380ljj.3
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 22:36:16 -0700 (PDT)
X-Received: by 2002:a2e:9bc6:: with SMTP id w6mr5685402ljj.156.1561181776658;
 Fri, 21 Jun 2019 22:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190621.212137.1249209897243384684.davem@davemloft.net> <156118140484.25946.9601116477028790363.pr-tracker-bot@kernel.org>
In-Reply-To: <156118140484.25946.9601116477028790363.pr-tracker-bot@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Jun 2019 22:36:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=whArwYU0KwEps4A6oRniRJ-B8K6VFX7gF=YGuFFaxDxqA@mail.gmail.com>
Message-ID: <CAHk-=whArwYU0KwEps4A6oRniRJ-B8K6VFX7gF=YGuFFaxDxqA@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     pr-tracker-bot@kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 10:30 PM <pr-tracker-bot@kernel.org> wrote:
>
> The pull request you sent on Fri, 21 Jun 2019 21:21:37 -0400 (EDT):
>
> > (unable to parse the git remote)

This "unable to parse the git remote" is apparently because the pull
request had an extraneous ':' in the remote description

  git://git.kernel.org:/pub/scm/linux/kernel/git/davem/net.git
                     ^^^

which seems to have confused the pr-tracker-bot.

               Linus
