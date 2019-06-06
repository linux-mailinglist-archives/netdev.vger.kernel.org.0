Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A5C36926
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFFBX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:23:56 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:38810 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFFBXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:23:55 -0400
Received: by mail-ed1-f53.google.com with SMTP id g13so771879edu.5
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 18:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wb9Lji0MwOt7HNHV7EpUWkPpkz3wzruJNrB3gQYmPnw=;
        b=ags/uuBlAZANxv8b5sCJmWCxA9UPb/l7PAm0vbzV6sdNC759VZ2ejzjRosy3z3rvT9
         yXHp2jDxNckpzpAE4pexqyLElsYde5stO+YxYdET/yjlseMEQXT3+2/wdcE2uIpfFYrj
         PXejjrrGJeumZG+Wck7PToLDJkQoL2G/ckUq10tV3FshSth44EmK7IXsjoj1G/TrdhV9
         7LJLH7BwvwLtIzJIpJzX6qqvbOPCC2WaFm2JZil+JkfYDkBqCymB54h9W5yY0RkBPcnf
         vfjiwrOkFLz6bNl3Bvl9bvAyMgg3Pm7FZKWwl6GQFIQTVEZ3ZVUGG5hSyWee7aIWrFhf
         CuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wb9Lji0MwOt7HNHV7EpUWkPpkz3wzruJNrB3gQYmPnw=;
        b=UeveNMRrrNoMyOfLr81sU+XkZk8RXH0CsE2IV0JxRLanj5ysBIHKmYkQEvV/3HD1Tf
         6iUAbf37svF/WaP0rSn5R9vbDSzZzWdXYtj5mz8joFZJl1C88g67T1w/qPeCpO2H9nNc
         YuSyi+nNsOIMGqndRnjJvVURINj7oZNObUQJscDKGAAiqewmIVIQdaIhDJfkH8nAIV02
         ijrUHZjLglNjB9ZDD1qsUSqX/nFrIXIpwl/UlNBE9E3fWGWR0VCEjeclVJADujXHSal5
         YRiT/aNEWcYQrBJ4KV+UzVDV2z5gHR+6ZhEVT//mqiRutq0eiv9SLb1QXstvAFwTzRUL
         jimw==
X-Gm-Message-State: APjAAAWuhQPc580mm3+D2oT+GvxSECTgSq48Txaj7vgGBlKBfMooxQm9
        yTJVRma23brbSsNQzVcUP2I=
X-Google-Smtp-Source: APXvYqxzDeG2s1kBmlS1tewE3tbZrwodVS725OKDVZnrIDK9qoH3Qs2IMlyJdfA/NuX9W1ZKH6j+pA==
X-Received: by 2002:a17:906:7005:: with SMTP id n5mr2930135ejj.155.1559784233842;
        Wed, 05 Jun 2019 18:23:53 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id i5sm84924edc.20.2019.06.05.18.23.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 18:23:53 -0700 (PDT)
Date:   Wed, 5 Jun 2019 18:23:51 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, zenczykowski@gmail.com,
        lorenzo@google.com, dsa@cumulusnetworks.com, thaller@redhat.com,
        yaro330@gmail.com
Subject: Re: [PATCH net] Revert "fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied"
Message-ID: <20190606012351.GA29571@archlinux-epyc>
References: <20190605042714.28532-1-liuhangbin@gmail.com>
 <20190605.175526.1448552541340120763.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605.175526.1448552541340120763.davem@davemloft.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 05:55:26PM -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Wed,  5 Jun 2019 12:27:14 +0800
> 
> > This reverts commit e9919a24d3022f72bcadc407e73a6ef17093a849.
> > 
> > Nathan reported the new behaviour breaks Android, as Android just add
> > new rules and delete old ones.
> > 
> > If we return 0 without adding dup rules, Android will remove the new
> > added rules and causing system to soft-reboot.
> > 
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Fixes: e9919a24d302 ("fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Applied.

Please ensure this gets queued up for stable, as that is where I noticed
the issue.

Thank you for applying it,
Nathan
