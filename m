Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F7149298A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345117AbiARPTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiARPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:19:08 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9C2C061574;
        Tue, 18 Jan 2022 07:19:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id e13so1439724pjl.2;
        Tue, 18 Jan 2022 07:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a1w+cgfBvHMi9BSk7YOfIx7gMi8ZSEfjap/hRbKJAZY=;
        b=a6+N+z3LLL2eIpR6WMmFOPvoCgz/iOjSgoB63GSSoa+UG8BYbejMfFFMAHu4axXd5L
         OCU1a03+GeDekipQgtBjfs3n2ynCKf2M2a0niiJY/f2RyY+wdyxZSVMY8jDRfGF4sVF0
         gl7aD7LD4HOwpe8tvJGY/uMRQvI0t3YhsUG5DVVEKORRIWk2R9CRzK/joW0XaDuomVyO
         snu29ssZBszP9oRfDKR3eQA6aYq9zv9CC8kz7+x96/sjL0xAU3yu3d4QV7N3wAGI41LD
         GMTO6x3MQKXmOdceCAXsAjQ4wvn5pOy7ElkfeViPl8MR/JotY+WUzrsnW1BQoMjwCxLf
         ALIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a1w+cgfBvHMi9BSk7YOfIx7gMi8ZSEfjap/hRbKJAZY=;
        b=CUUMVeWurRUVkJaGHNbC+5LcdF+nXpxr1kgiQcIgmFAjr3EopHFeJpBzORf5b1sjcI
         6hJB6FShKrtj1/cRPYOWDcoPJnYpkZhf/5/p7a/t9Zg10OPa0vVa3KUuLmXhpmGLCr+S
         5sir2GzAEpjyExBrtKovlI5aQPjeGF5AsP83HuBhJ6zuejGFV0lfrLA7YXsp3U6d0XLE
         DwdlOju2b/SXyN4uPfNDRxuE433wK0ByNUQcE3OGsQrETlOZVGF9CY3Vsk/OAiQ4PsKc
         ZRg2t8ewhdkQ8ZWEG635f7oDONlT0l28Kaa8tCnmAQM/WbzE56mEfm27cklavRYdgZRO
         Io+Q==
X-Gm-Message-State: AOAM531jHfWUaHF0q+GkfGZDuiZ6dfuU68env1PcGitiVbPHnAbGoW/N
        wPsGL+rOsRG5MJeXrgN/oM0=
X-Google-Smtp-Source: ABdhPJxJ96loOG/L3H86yKOUymJkuNBWxl27xmbjSYhAUHWsRK6N70bxzJ3yOVW1skk9NZK36Ujyvw==
X-Received: by 2002:a17:90b:3892:: with SMTP id mu18mr13349099pjb.51.1642519147804;
        Tue, 18 Jan 2022 07:19:07 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t3sm18724613pfj.137.2022.01.18.07.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 07:19:07 -0800 (PST)
Date:   Tue, 18 Jan 2022 07:19:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     cgel.zte@gmail.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] drivers/net/phy/dp83640: remove unneeded val variable
Message-ID: <20220118151904.GA31192@hoboy.vegasvil.org>
References: <20220118075438.925768-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118075438.925768-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 07:54:38AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value from phy_read() directly instead
> of taking this in another redundant variable.

NAK this is purely cosmetic and not clearly better WRT CodingStyle.
 
> Reported-by: Zeal Robot <zealci@zte.com.cn>

Please make your robot less zealous or filter its results before
posting.

This is the second time I told you.  It isn't wise to ignore feedback,
and it is also rude.

Thanks,
Richard
