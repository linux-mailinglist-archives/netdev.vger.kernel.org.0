Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E058D1430F3
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgATRpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:45:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32868 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:45:45 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so91653pfk.0
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 09:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FfZsEUGhci87toFKwCPKy2xTbao720mFpF42PG1AW7E=;
        b=M8pHWEERkYW9JLbQnCu//xBTQE2osFBG/uPfwTFDNeRvVPzk3WxgtqpbBltrI59Eb5
         ODmpSshTPqOTNYCNbcf3p8+awXFS5PaXQDpQJPK2vdEi6c6w4wGGh2ZjW4Mody62z0H8
         18olhCnvnXnHA4bwUwUt24shMEV0nd6EXJZFB3uPL7x62FNZvVjciK1qZYwdct9PtvEN
         l9LZGzFEQca79+7GoLhwu6oblbOT7gNEtDJtTpJB/AVR9f8OSzpRQFMlICBtoQ8xc6OD
         rp8z9sqHS41OxrA65agFozSOQSi8/bg7HeUsTo0E0/OqjFvGhHrUFhWzrTBeCcc0dry4
         H7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FfZsEUGhci87toFKwCPKy2xTbao720mFpF42PG1AW7E=;
        b=WJ9kmhG/JJ2oC6UPNEPamSNIme4fx+/Ah/Yj8Iyqkn+oosTwxMxZeCCfGzhH43IVet
         g7Vmd45AqMN+XkT8hkXJ6wKKyChEEHn68hbQE+pxVPbdx0wACFymomAlfysyPIzu47kz
         FnhqTV2lgDuUtkduP6NlBV+jrGHSRmnwY/QED/f17MmnPQI/qEsQyxSIYAVXx/vOVq8n
         VzDYIHUbLz1qX5Z5Q708JS+4gjH3a3WNuGQbHyvWWbXgh0HDhMZhab7s1TNPkSQNJTWL
         CRRqwEV2cvISuK5H+0mwT1dmRz+rN8GfjT2HY8T3jyHTf1nsiirrYwJygo36dJ1TaN4G
         fcrg==
X-Gm-Message-State: APjAAAWCwKXDCnfhluKyoczpUim4VzTZLnJHpKUDN4+DBCsX2sXobm2S
        9B/jG8YTqtJiTIvZVsC3T6AF6A==
X-Google-Smtp-Source: APXvYqzfjeijfUhVM+co0I0pHYH5wMQ8O3AS3tsiw8FhLuhJ00uqSSf9Ir+fZlQjwgfIszNeqWr6/A==
X-Received: by 2002:a62:296:: with SMTP id 144mr329946pfc.120.1579542344823;
        Mon, 20 Jan 2020 09:45:44 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y203sm41322753pfb.65.2020.01.20.09.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 09:45:44 -0800 (PST)
Date:   Mon, 20 Jan 2020 09:45:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ethan Sommer <e5ten.arch@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] make yacc usage POSIX compatible
Message-ID: <20200120094513.639114e7@hermes.lan>
In-Reply-To: <20200108195705.15348-1-e5ten.arch@gmail.com>
References: <20200108195705.15348-1-e5ten.arch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jan 2020 14:57:05 -0500
Ethan Sommer <e5ten.arch@gmail.com> wrote:

> config: put YACC in config.mk and use environmental variable if present
> 
> ss:
> use YACC variable instead of hardcoding bison
> place options before source file argument
> use -b to specify file prefix instead of output file, as -o isn't POSIX
> compatible, this generates ssfilter.tab.c instead of ssfilter.c
> replace any references to ssfilter.c with references to ssfilter.tab.c
> 
> tc:
> use -p flag to set name prefix instead of bison-specific api.prefix
> directive
> remove unneeded bison-specific directives
> use -b instead of -o, replace references to previously generated
> emp_ematch.yacc.[ch] with references to newly generated
> emp_ematch.tab.[ch]
> 
> Signed-off-by: Ethan Sommer <e5ten.arch@gmail.com>

Looks good applied
