Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C50869FBE
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731734AbfGPAPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:15:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32925 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730623AbfGPAPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:15:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id r6so13446982qtt.0
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 17:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mGLcFoi2noLeTaUWKi9eL7v73PQm/ALxgkUrR5U7mqA=;
        b=YunTNJXA4HvOumMshpF2VJNxH0MvBUJ1Gvknnye3YuqfSDo+U+CEotHtOQM3y6jG2L
         1zv2uA5eNRMTAgN80F0N6F1x2Wzm/wHDEPU2aX+75aZrj+2DVVaizX3LAEdoreY+FYfa
         eobxmFFRXBTjpJVjAGkTSmmdFX5nl92e610WTBm0PuqhZqcSnlylQLD71984b5gRBb6l
         tTF4hzMsWIsChrulQ4cwfZ1yYsHwpY/5GqXjnP2Kb3muM2xTjZ6WxaceSCnM9zh7SyrI
         7coARvmmFxYR81rw47vs6KTmhrBvC6RPvUtBOI7p9EWl4cp66BoE134D2K+A22v+9WlS
         SL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mGLcFoi2noLeTaUWKi9eL7v73PQm/ALxgkUrR5U7mqA=;
        b=M+cEtKqSfBUr05y/jFcMp/6YguD+h7jfTalsvo4PvUrKoboIS+NZhM+l8q8KK9pvnx
         wPZlkO1E67VILZopOIwG04tfyEVZLoZCHwFcxBVJ/aAYtD5INmegalkaR8sapTpgeBnJ
         tsmtS6b57eYOVXbzd1hTvdyDShK9B73zFJIOvxIIhTYvFCpmOcbIIEFnp6tMk8dwDBcn
         f4afJdlHKSwESGzM+YtyOTN4ekVQ0pKcWUeZS0v6ib/+LIa8iW2rvuXEHrobspNNT4hQ
         3bjnPW3/JWiBgKAYzAysYavkqbBBAdRF8ZJo64LDGrTU3lQNS4EOnINhKdEib+3+TzYK
         cTDQ==
X-Gm-Message-State: APjAAAVQtlMGFiVPu4SI+2+H5pZrPqN1fcJrF/eII9K3DpFKtO3wbL1D
        rBPI5At9h5snDeSavAOqUrwCToNe944=
X-Google-Smtp-Source: APXvYqxhSfT1UAsXSj5T8ML4jl3PBG/bDOethW5HnCRwlgMxuobXycdoh7U3RFbcwWNmHuMxDAbxxA==
X-Received: by 2002:aed:38c2:: with SMTP id k60mr19340619qte.83.1563236120727;
        Mon, 15 Jul 2019 17:15:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t8sm8251276qkt.75.2019.07.15.17.15.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:15:20 -0700 (PDT)
Date:   Mon, 15 Jul 2019 17:15:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, leandro.maciel.dorileo@intel.com,
        m-karicheri2@ti.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2 net-next v3 2/5] taprio: Add support for
 setting flags
Message-ID: <20190715171515.248460a6@cakuba.netronome.com>
In-Reply-To: <20190715163743.2c6cec2b@hermes.lan>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
        <1563231104-19912-2-git-send-email-vedang.patel@intel.com>
        <20190715163743.2c6cec2b@hermes.lan>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 16:37:43 -0700, Stephen Hemminger wrote:
> On Mon, 15 Jul 2019 15:51:41 -0700
> Vedang Patel <vedang.patel@intel.com> wrote:
> > @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> >  
> >  	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
> >  
> > +	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
> > +		taprio_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
> > +		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
> > +	}
>[...]
> 3. Use the print_0xhex() instead of print_uint() for hex values. The difference
>    is that in the JSON output, print_uint would be decimal but the print_0xhex
>    is always hex.  And use "flags %#x" so that it is clear you are printing flags in hex.

In my humble personal experience scripting tests using iproute2 and
bpftool with Python I found printing the "hex string" instead of just
outputing the integer value counter productive :( Even tho it looks
better to the eye, JSON is primarily for machine processing and hex
strings have to be manually converted.
