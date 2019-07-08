Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8C061FA2
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbfGHNjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:39:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52928 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728839AbfGHNjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:39:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so15849090wms.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 06:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IZYoTJNMUB5ITuK5Jz4TO4Y6NEUU7t36OmN+2pdgVas=;
        b=M6pHig+lf66IicudAiau4snItiKq+pzEujMGDpP3rXi+mVPn2bEya5WDXJC3f01Pxr
         KnMzL6JdZ1kTf+UFqXGvkDG+NEVX08kBR1qjK3o3CiF5tIhr61HpLfTIisKf4GBMDvhc
         3up6cEwNB7MlbRqP1UTv12CdSqANlDJQ2szHni0n4GSkjheXlkEQgENjmt44vmxUTBnB
         iQrENNBrfRm7YTNtAXSEkosAQSf+Gx8lAN+FA5PjE/Bhx/9RtS4Gu9zXE1IZKdjs6EyO
         9aHbcsq0HAQLq0Me+cPgK1jTslclgqzIieitAImgaDSyuZm2pkb2bVdXWvRGlekV/NsO
         fiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IZYoTJNMUB5ITuK5Jz4TO4Y6NEUU7t36OmN+2pdgVas=;
        b=I2DiCgjqj6MINn13tCNdgG048foDE1ygGKvvkDFJ+9oMOrhliB5+I1CX8yTQK57Xs8
         qJjHWJB5zV1IAkZbonBoKlG3LXYpOD1DnQz8V3el6ZgTGwZp2lRbmOVkCitSVsv9TMg6
         5ivswZy6D2ys1D5+w9YHTMWBzCCaelLy79aAFYU2z83QSie6Z7Oe/YiJ3h4Uw9MpSVDG
         YqK2OmmnMH/ja+t9kbDWlAHYKkGh6hfltg4atxXj1VFKtyqyJfR7JB9iwe9V8lzBGQDc
         BlKNB8c46scvaBIPcdDAQfmGcZuSVD85yoi+0KYTW9i76wAf6lPv3kJK+obWcJ09hXXk
         wM0A==
X-Gm-Message-State: APjAAAUcaLQVGXXMOBikGT4rfjlwz+Y/XePrOV+meJ5HPgDmHdOrnNVO
        ExovP1KAgiDWl3iKvGjtm5ataA==
X-Google-Smtp-Source: APXvYqzS9b6zYQAiJ6xat6OmDid5KuXj5kObGZlyo0OXzPTNBagbiQb6MFFxEYtltletgyhG3BJXUA==
X-Received: by 2002:a1c:6882:: with SMTP id d124mr16658717wmc.40.1562593144893;
        Mon, 08 Jul 2019 06:39:04 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id p26sm25929218wrp.58.2019.07.08.06.39.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 06:39:04 -0700 (PDT)
Date:   Mon, 8 Jul 2019 15:39:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 09/16] net/mlx5e: Extend tx reporter diagnostics
 output
Message-ID: <20190708133903.GI2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-10-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-10-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:01PM CEST, tariqt@mellanox.com wrote:

[...]

>+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "Common config");

Are the values in this section "configurable"? If not, I wouldn't call
it "config"

[...]
