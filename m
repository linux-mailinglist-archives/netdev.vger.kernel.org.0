Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA669F8F
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 01:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbfGOXhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 19:37:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43688 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbfGOXhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 19:37:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so8445824pgv.10
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D6cmxh/G160rFpo8s17a+dCwrfrc+faraADkJwLTnaI=;
        b=kl4l+8zSsllrSRyouepVoWAKR17lBrcXosCi5nd60XdMxa97Oxkx3eV4DazAhIHNQq
         TljAaVsS9hM1+TGWLoC2v3t5mhjGNp6eDC3mLfGfpM6c7xiTrOlAJgXMAx+AIqLefiGJ
         XMlYC+8WIRZwGebmsYsysqI4D45QKEmSQyDR2D/+hmS1AXHYW82l54FfcqMKfGbrpXMa
         jDdAD3z99AeVQdhk8cU8v0+PYOpVEEFYwksEElEJEqLhO3kzbG7cfosgyUzDGEocS4ZO
         Dnvky08Mm6r1ccexXwlCg3QBoCbnGtRZ2oMl1Px8n84tk9B2m2CDHk3UZfFzDFDqiC5N
         khaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D6cmxh/G160rFpo8s17a+dCwrfrc+faraADkJwLTnaI=;
        b=UTKacfdhBP6d6FK24NOOnVj4Fm8xSoM2wStoqMioTI9fx1uJBlBZwPfZbZJ6Nfkj0D
         x/rZpgknPf1tBxr/aWViGCk/vJOVvcNyTl73sNk18GEQHcHXaalr3biL9W4JVlr53g7e
         5qQLdxnUD+f2W4Xt0yKB3IpZYd8EA6apoYKbA5p7mlH9oS81VO4J2y4NriIqaUhEpK10
         OL24iEvRTtEnxUXjEDJ8Us4IRH81YYkI5UuMAWj4KqDRSvr7M+rbg4U1UnOwobhH27l9
         tjlm9Vgw3FkutSjPBdj5ei5yBt91FbYOdK7w6gCefsEEzHP5Gf/16Gsles+Gdc3drszI
         ZDrw==
X-Gm-Message-State: APjAAAVNgVQ5yAGAA2kULFpcv8yN1PVbLH95Gto4VYzLHVWwCXVOIPt2
        O3VjF1HqAjOHGR5ZZAmMdKE=
X-Google-Smtp-Source: APXvYqwkl+0E6/DAxEIVFL1rOKECnhajT+BDmnh/oy6YFqoKNsA4TqHdkYqa6Xx6OJ5PJ9bwxjk+cg==
X-Received: by 2002:a63:5765:: with SMTP id h37mr2977728pgm.183.1563233871856;
        Mon, 15 Jul 2019 16:37:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y22sm16923360pgj.38.2019.07.15.16.37.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 16:37:51 -0700 (PDT)
Date:   Mon, 15 Jul 2019 16:37:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2 net-next v3 2/5] taprio: Add support for
 setting flags
Message-ID: <20190715163743.2c6cec2b@hermes.lan>
In-Reply-To: <1563231104-19912-2-git-send-email-vedang.patel@intel.com>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
        <1563231104-19912-2-git-send-email-vedang.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 15:51:41 -0700
Vedang Patel <vedang.patel@intel.com> wrote:

> @@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
>  	struct tc_mqprio_qopt *qopt = 0;
>  	__s32 clockid = CLOCKID_INVALID;
> +	__u32 taprio_flags = 0;
>  	int i;
>  
>  	if (opt == NULL)
> @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  
>  	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
>  
> +	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
> +		taprio_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
> +		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
> +	}
> +

Overall this looks fine, but three small comments:
1. It is better not to do unnecessary variable initialization
2. It is better to move variables into the basic block where they are used.
3. Use the print_0xhex() instead of print_uint() for hex values. The difference
   is that in the JSON output, print_uint would be decimal but the print_0xhex
   is always hex.  And use "flags %#x" so that it is clear you are printing flags in hex.


