Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D138B12AC50
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 14:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfLZNGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 08:06:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37360 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfLZNGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 08:06:20 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so10979330wru.4
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 05:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xo8Qal3mjgfRAlhm5jkjBld51g1LJYiU470Ro7Ld+tE=;
        b=YBnpzQSYKhy0UkxHTR+kMAdGuPf2UgK1bHqumiXsrMqbZMJD15ErqyAlYTJEvF8tHo
         jLix+5lJsQHMbQc1QtByhEnO3og9Lj7bSaHvhF7Ja6ZDf6TmKzLq3LvIqLZAOO8F28Ue
         giFVSXm1a3nzyoHSvLpra6g8gZUSM5WeLVKJgfDXrgjuMS+ivMaO8Ydo2IxMCxJX/26+
         YkV5vUkqINVFx6JBiTHWWzg4kPSUzH41vIms+YV7iF5nEQCGTrEGU7G6p5sjErRNSOTR
         pMV/6k+sipvNnHx77f+AIV5qcjuulBEXeRpb9hi4c4qh8EHyHPjsRP32pzuCNpTpvfuV
         ZLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xo8Qal3mjgfRAlhm5jkjBld51g1LJYiU470Ro7Ld+tE=;
        b=mgUqLSLsz6O+83GgU7hjkjHeJcEioKr4wz2KtPFO8L8iEwQGkK+iHAqXfQ5JGnMCgY
         CxDLWjCjqhOQPXluY8gdfPGnudmPgRRHRCgRNItmT6qwTRpaM3J+pHTfP3cNT02fX4K9
         KTdw36clOrcOoCS/LsAK3HZAo7qP5tQGBSrPCssI9tU5WIIkIy7p+OD6YuXSRpsQgnTR
         z0UQ85/oQ8XbzzZ8TMmkzSn3eT01tUfpwwmQyxBVqrWyRMBjz9ZNKSb7TXb/wjrziHnL
         gr+QUiLVOhsd5FXEwTR5/Mw7c0BvaPMkTqmkka+mppqUonfTKaoZWg1VO4rNN+RDEKHn
         RTFQ==
X-Gm-Message-State: APjAAAVAdZjl/oFh+76yvUXh94W55pzIhAQeS0PseFAQ2gDgD0SkUhxV
        IcFEgxf70WJwklPq+VQHzXBzTSGO
X-Google-Smtp-Source: APXvYqwIm4RIYvztQO3higHqaWZpPnDfhJz+TbkpycZ5/Fw93CuHgvIxd87LZl7s6e57h0DT4Rkn9w==
X-Received: by 2002:adf:82a7:: with SMTP id 36mr47608774wrc.203.1577365578072;
        Thu, 26 Dec 2019 05:06:18 -0800 (PST)
Received: from peto-laptopnovy ([185.144.96.57])
        by smtp.gmail.com with ESMTPSA id i10sm30980167wru.16.2019.12.26.05.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 05:06:17 -0800 (PST)
Date:   Thu, 26 Dec 2019 14:06:15 +0100
From:   Peter Junos <petoju@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ss: use compact output for undetected screen width
Message-ID: <20191226130615.GA29536@peto-laptopnovy>
References: <20191223124716.GA25816@peto-laptopnovy>
 <20191225123607.38be4bdc@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225123607.38be4bdc@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 12:36:07PM -0800, Stephen Hemminger wrote:
> On Mon, 23 Dec 2019 13:47:16 +0100
> Peter Junos <petoju@gmail.com> wrote:
> 
> > This change fixes calculation of width in case user pipes the output.
> > 
> > SS output output works correctly when stdout is a terminal. When one
> > pipes the output, it tries to use 80 or 160 columns. That adds a
> > line-break if user has terminal width of 100 chars and output is of
> > the similar width.
> > 
> > To reproduce the issue, call
> > ss | less
> > and see every other line empty if your screen is between 80 and 160
> > columns wide.
> > 
> > Signed-off-by: Peter Junos <petoju@gmail.com>
> 
> I would prefer that if the use pipes the command output to a pipe that
> the line length was assumed to be infinite.

Good point, this is used in min().

> > @@ -1159,7 +1159,13 @@ static int render_screen_width(void)
> >   */
> >  static void render_calc_width(void)
> >  {
> > +	bool compact_output = false;
> >  	int screen_width = render_screen_width();
> > +	if (screen_width == -1) {
> > +		screen_width = 80;
> > +		compact_output = true;
> > +	}
> > +
> >  	struct column *c, *eol = columns - 1;
> >  	int first, len = 0, linecols = 0;
> >  
> 
> With this patch, declarations and code are now mixed (more than before).
> I would expect something like:
> 
> static void render_calc_width(void)
> {
> 	int screen_width, first, len = 0, linecols = 0;
> 	bool compact_output = false;
> 	struct column *c, *eol = columns - 1;
> 
> 	screen_width = render_screen_width();
> 	if (screen_width == -1) {
> 		screen_width = INT_MAX;
> 		compact_output = true;
> 	}

Seems good, I'll send changed patch soon.
Thanks for review!
