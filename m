Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7209DF21F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfJUP4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:56:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34043 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfJUP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:56:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so9474501wrr.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 08:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CmEdxoNbRQd7LAzhB4FGMMHiH/RujzV/IQaEREtmZqw=;
        b=vwzeY6hZE66GqYjD+LsheuzDC+U4g2RP5VS758w4F2XO0dA2U/Pm02pMtZcYcQnVNR
         LCzGZ8ZtZfp4y+JNGK8dKTClCT52k2fP5PQvcj7l6+5JB9PcVDLBxShobZp0tuTm+ihp
         7B9F+cVqSpQ7XAB1niWSpOaGAE8tNvpcAQY4Is+msvcOVEfxOjNodPsxujT1x8AMpbq5
         /8eDqnhbVfkvLbK4tg+IkU2TCat8TSJO9EJmGbV34V2uB4lZBq/5knl2W1EKh8gfw++v
         xMDzJFrF/u0IbicObrYfud5DL7rNVixl3x0e8RL1G1iFka/MrjhoFWGBM5afeXDzPiLW
         G6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CmEdxoNbRQd7LAzhB4FGMMHiH/RujzV/IQaEREtmZqw=;
        b=pcdLHy45DfscwGZOZoBxvjt9IKzYo68XFecj9PH5psE/KIEmZlniMqg6C2iIheX4Dn
         SuRLrJHShZy0Vk1BDSQAXlWvmvH6hX97Cekz2mOI6vvW9+q7vA9A7WreFD0pyRm3PJ1Z
         uTYsAXBAzYJWBL6DuUr9lEfoPFFD5H+MaTEYFpMjUOzrPJFUaJMlt035x7x4vDPqSz8k
         ts7R5dG/w9qrNSIoBFSG8UAvswF7IiY8i3lKwYbOp73zwIesMttSoPq7EndAWNNN8uj+
         bZD+eKtg27X6fa0O8Xv3kJIQZxX6Pus9JUP3lW5dPqAUKsCebTmJ9wK+KYax2D0RSc0z
         ORjg==
X-Gm-Message-State: APjAAAU7BTrk5f1Z1U/LpLFxwEhRHhGgRyfIm8uDci4R2T6DORiLbprL
        zdgqxs4qazvz6VhC6bziSjR8wQ==
X-Google-Smtp-Source: APXvYqzGbl31OPltW9DTXoxPC2GjjwcStpsaavqah1FsOBDyBSr7umj2KA/5xxkMAFZoXxJdNfsKGA==
X-Received: by 2002:a5d:6a02:: with SMTP id m2mr5809125wru.304.1571673391795;
        Mon, 21 Oct 2019 08:56:31 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z9sm15154953wrv.1.2019.10.21.08.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 08:56:31 -0700 (PDT)
Date:   Mon, 21 Oct 2019 17:56:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
Message-ID: <20191021155630.GY2185@nanopsycho>
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
 <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 21, 2019 at 05:20:07PM CEST, dsahern@gmail.com wrote:
>On 10/21/19 8:26 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently, the name format is not required by the code, however it is
>> required during patch review. All params added until now are in-lined
>> with the following format:
>> 1) lowercase characters, digits and underscored are allowed
>> 2) underscore is neither at the beginning nor at the end and
>>    there is no more than one in a row.
>> 
>> Add checker to the code to require this format from drivers and warn if
>> they don't follow. This applies to params, resources, reporters,
>> traps, trap groups, dpipe tables and dpipe fields.
>> 
>
>This seems random and without any real cause. There is no reason to
>exclude dash and uppercase for example in the names.

I forgot to update the desc. Uppercase chars are now allowed as Andrew
requested. Regarding dash, it could be allowed of course. But why isn't
"_" enough. I mean, I think it would be good to maintain allowed chars
within a limit.
>
