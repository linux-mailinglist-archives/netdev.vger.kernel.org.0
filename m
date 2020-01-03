Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE2812F531
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgACIJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:09:00 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42203 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACIJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:09:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so41516561wro.9
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 00:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0k7Nrh4x1bxnz8GzTdPqEDCA+YMCLn7XncTfywGPxRg=;
        b=sp00besKD+z7sl/VVocpJ4qZvP6wGluzlgsFu5UjhdwSxJdo802aEbAfP/rdWTSVUZ
         c/TSciAQzCSf93pnbdf2t/vyq80h2L+A3E8HiPnz3J9t803wSHFMJsVN282pnZRQ9dej
         DM9gOMieDUUQEq28w13NC0kifC/4ZW/M1NoUDEcz37JOV/6MJD9X2Nc0+VOW7/hiFgXs
         VzcIqDMDm8hd3IXh6aCJG88vKjwWu+nt6n1I49EbNldP86b23pSd2UEdgy0GyZILSE8D
         GyPcxQCznFjVeD0gYi0O3FElDmUnH5pCibml2lC7BvkjOdWVWajFQsONj1V8PSKpeVh6
         cv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0k7Nrh4x1bxnz8GzTdPqEDCA+YMCLn7XncTfywGPxRg=;
        b=bw/gj21YJsudGNOzjnZLWHUhDeI+qmJz7cr91voxrGNv8C9rnS2XRhKuE5QgjW0vDS
         njLNwB41Bl2tQd1d/LIYIfMoRf4gaB6W8uMio4XP/frOMzrbVZJStzH3k8gYSbpFptqC
         RCBPHef/ILuuG5KypektCRilRCsNEaRJrZw7pwZPwWvkoRVIPgY5bh98WYd3jKkCmU/h
         zFmW7T6osMZp4I8PTKtOGyRQSmCn9389oofFqdLElQu/vbGCQS1l+za0sEk9cFpylAwv
         IOkM1oQ42X3fq8vg0eZbd1JnhMbwUjTP/WjW4oFPW6bgjYNjjOEoyOMPQQNRnnEhrmWF
         Zk3A==
X-Gm-Message-State: APjAAAXVX4e8lNf1+dXPfv3iYYlT62NUEHBZO45KIUeM/ZYd2EA+w3QY
        kk77uYzlXvyHwpwvg1qE9xE0kQ==
X-Google-Smtp-Source: APXvYqyeyVk9xRFjXUP3MDNj8/60ZhWL4i+3IIdWmdZa26LSISYAHYQ0dO5Lo6MUxPaxBsLAgMGrhQ==
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr90721736wrn.320.1578038937957;
        Fri, 03 Jan 2020 00:08:57 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id y139sm11779352wmd.24.2020.01.03.00.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 00:08:57 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:08:57 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: Update GIT url in maintainers.
Message-ID: <20200103080857.GD12930@netronome.com>
References: <20200102.174602.1527569147186535315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102.174602.1527569147186535315.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 05:46:02PM -0800, David Miller wrote:
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
