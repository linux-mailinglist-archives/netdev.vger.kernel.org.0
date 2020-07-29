Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFDE2326BD
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgG2V2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2V2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:28:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCADC061794;
        Wed, 29 Jul 2020 14:28:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so13755341pfu.1;
        Wed, 29 Jul 2020 14:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hI/UDvzDKwJxsEwkWoyUq5HDwLFa3gCvalT8b4tfo+A=;
        b=B6ID/6nhaoNkNEFEeURwR5BuNj8Qg0WgMuALePZQL7c6lRbAuoYQqQ9ql4hICselAG
         4ltQUG7F1t6IkfD+NaZYvepg+7aK3Am3neCcQiSYlvUTWjfOEU31oEB89uzWAjWEDAa/
         y81K+8QR7Qb35KWJ1TfsJWIferT7z3dV4Z/d4PQJCQn4SFWFjILcIbzo9/EYYyYJmhGy
         8VcjaOumCapnmcwgS2FFRZor6+PmXdDGVlALRPRw1bzP3aHqfYKuWcz0ZZ6w4PACjhfZ
         rrZjReaG4DMo4YnZbXhxe8BdcnC9AMiu9iZNxxX0DhdAU2IbnYyIteru0Gcy/90ri4tg
         iTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hI/UDvzDKwJxsEwkWoyUq5HDwLFa3gCvalT8b4tfo+A=;
        b=HCNhkKJMOES+FId7eo1/nHZOgtasAVZxOipVkVIsciE+2e+FUwUUGGZ29mMOQRCHJX
         ZtflH5BchTTcdA9ClVHPA7vW6n/8BlYzpwMjrcEWh7HqYd8Hxv5LPreGu5DdLVxSHGOC
         AeUPPGP10RmwpM5hbsRuNlomMJ9AuEOTaPyZB+njKwmhaCDkA+dNxeo10s936GxFy3rB
         9AcZWlCmuY+WtHud1u9lY2J71p7F+gRpFtIUoX+Fvp53QM5cgACmWC7fktcKkcqrDwQB
         KyfJLW5rX1J+XFz35vNU8HWT7bpv5PYAOku43XFeFZTem8JRBNhHVXZYM9jN3JSX2D9X
         Mqkg==
X-Gm-Message-State: AOAM531ErgE3T1R6Ir5J/ahcSLTWq/381ECrOVCdQD4tzN8WW+KV/Qp7
        16TvWf0bIt/M8JlrwRMq51h8eg6b
X-Google-Smtp-Source: ABdhPJxRdhyvP1sq/AERRxp442XYXHIylVvaWRHbUhKDK6UERUdYZgsQtdrzCuBzOKxOcrsae//Qcg==
X-Received: by 2002:a63:3441:: with SMTP id b62mr9972897pga.25.1596058113382;
        Wed, 29 Jul 2020 14:28:33 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t19sm3187499pgg.19.2020.07.29.14.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 14:28:32 -0700 (PDT)
Date:   Wed, 29 Jul 2020 14:28:30 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ptp: ptp_clockmatrix: update to support 4.8.7
 firmware
Message-ID: <20200729212830.GA12513@hoboy>
References: <1595966430-8603-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595966430-8603-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 04:00:30PM -0400, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> With 4.8.7 firmware, adjtime can change delta instead of absolute time,
> which greately increases snap accuracy. PPS alignment doesn't have to
> be set for every single TOD change. Other minor changes includes:
> adding more debug logs, increasing snap accuracy for pre 4.8.7 firmware
> and supporting new tcs2bin format.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
