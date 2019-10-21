Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1D5DE5A0
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfJUH6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:58:35 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35943 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfJUH6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 03:58:35 -0400
Received: by mail-wr1-f54.google.com with SMTP id w18so12141323wrt.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 00:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A4bGjzb3hhrzVvQqrOrDzmFH3le5JnOZncJUfwtGVCg=;
        b=gn6GSNtC4P6agOXuGGjnBqbzMgOqjek5R4FubZE37WqK/ZcA687OY8HsFHeV92RJKW
         fWxkNnkPmyxJkQtq9RcoiSOFQkwKTl/MeZn3YR3txf3/nBIsyacOGM1cLwRqM1rvcCM0
         DYmyUs78CyDvT8LCJGTFMQ56LGp/rWHswt0lA9RlLMuT8RZ+GPfpgTEsnbn15wKXG/Dy
         ExdlBrMEW1kVxmJCYmX1/wtpyFNy0EzBvju4TGCupUiOzgf+KIlyT+15ibXNduklOVUb
         eG40t0Cr5H6u1XaQ3pMIhh+upN1KwBkTmSk1nrZiF02o15VwRSpgZvkg4tQ98MRLxyLL
         4AUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A4bGjzb3hhrzVvQqrOrDzmFH3le5JnOZncJUfwtGVCg=;
        b=hC+aeHc8YE6dUCdGxTXNFao3w00z8tclcly4InIot+JXwGtAv62j2LQq54DZkaqzEt
         UlGdYraexndZ4v/sEHEJjVYkCtgK5bq9I1+UiXUGOBvspHhs+R3LJyQUUZSogtnnsaWk
         UAe3LYdH2FOgvslheZKf5ZfFEELgi+ZAsmta7DkHbGL6g9nfOoQ/m/Th5Ktf0LNegZqs
         9Oih42GZAt/K04ugN9QqwYJgO7yUWJVouHnSGrgkJ2xihj1TFdZsY73MFsYQ/MEuAGm7
         vPcjWg+/ylnF2q/eevhr27UTS6iwdF3tTk9JwgSYEEkf1I77WYJpHnbTpYwfotQi7fiA
         X1IA==
X-Gm-Message-State: APjAAAUNOADlLf47gS/ZelGx5aOR7WGauOb6UTSe0inTb34WOnOGRLek
        xV3Olw0WZvIKqnQ4uhQtL1DKY2lNBc0=
X-Google-Smtp-Source: APXvYqwA0irUL9aNtW0snEuhAXWnMKtDu1NzxB7mzmiZke+5fcoatVeIAbdp3XrGWajgsHwNLUCCKw==
X-Received: by 2002:adf:e585:: with SMTP id l5mr2734823wrm.156.1571644711391;
        Mon, 21 Oct 2019 00:58:31 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id r15sm2460225wro.20.2019.10.21.00.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 00:58:30 -0700 (PDT)
Date:   Mon, 21 Oct 2019 09:58:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2] devlink: add format requirement for devlink
 param names
Message-ID: <20191021075830.GR2185@nanopsycho>
References: <20191018170951.26822-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018170951.26822-1-jiri@resnulli.us>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 18, 2019 at 07:09:51PM CEST, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@mellanox.com>
>
>Currently, the name format is not required by the code, however it is
>required during patch review. All params added until now are in-lined
>with the following format:
>1) lowercase characters, digits and underscored are allowed
>2) underscore is neither at the beginning nor at the end and
>   there is no more than one in a row.
>
>Add checker to the code to require this format from drivers and warn if
>they don't follow.
>
>Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>---
>v1->v2:
>- removed empty line after comment
>- added check for empty string
>- converted i and len to size_t and put on a single line
>- s/valid_name/name_valid/ to be aligned with the rest

Will send v3 which would allow uppercase and will make it part of
patchset that would check more devlink strings.
