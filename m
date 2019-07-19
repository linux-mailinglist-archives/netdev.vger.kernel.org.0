Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853BB6EC82
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 00:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfGSW0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 18:26:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35356 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfGSW0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 18:26:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so16259415plp.2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 15:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnR8BrJAdzpK8A9ggSy7QXNN2TyvazmClIAxZjUuHXM=;
        b=0LqO3/LwscMuOn49hrML9bfufFlBWe2VZf8SfCGPGXVFEHprCs3sCL29h4SKmx4vsS
         6utlUhEFgB6qvgczfwPyuEMbfQPd/M7aYCSBQWNT7b97VT297DARiDciQ+d9L0NE65qj
         Sh8hkJfa3frmjjdeyH7XdOneKvLaBPAcdz5nVeg47f7D+EyXLgWzG3ZKzKUFRp0t8QD+
         IxPgmpazB7sj2yVjxfGyP6KhY6+3fMQBc3dBgF5dJgpWx5z2g4jhks28H53HLv+GC37W
         2FfPdVRVEKkMzS7UJOE2U0aOJeTEI8EBDGkmsNe3jbvURB6UGxSrsOvAuEQekxDB8mMD
         FD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnR8BrJAdzpK8A9ggSy7QXNN2TyvazmClIAxZjUuHXM=;
        b=Anm2sjeJzg7AQzgXhjnP/CQg+EoPF63n4OS6vttHTDPmw5ssDak+A/k979l1reJYRD
         5zUP5fdRDQPwh8yf69WatL2fKhvK7QMCsDoa0RjW1IPULi6nRjxxOuyRdB+A2Xe01TCO
         4850UNiIfcvhpCrUXw61UQp8aPQgO8ewmvf8+xrjkinVNBXeo7gPoJENZ69lkY57XVAi
         ZvnR3jghT9l3vWjDcAOdZEb/88I7Jq5WlDAZTTxY9qgU4gTmOTbfYuNx3jZILjx2YHvB
         m4GilDKc1YCKZkGGuw0Dfp8kfBeJW2qP26vRZpPmeYXYCTS6uNSlCZy43+3oIva8RlHu
         6PGw==
X-Gm-Message-State: APjAAAVHHqGnuoFzm3mqG14fK0LNboZB/nPWQEY9ZaWXY3Y7BwW/7NxL
        /X39z8Iq3iZJ1gCfqiGxcAY=
X-Google-Smtp-Source: APXvYqxy29jwHpvZfUZ71RCG/xI71r9T/tZxgvzVzJ5cHvOkGBEaARcoA9g8NbQTa3WeEgZeo0fikQ==
X-Received: by 2002:a17:902:8d97:: with SMTP id v23mr57823423plo.157.1563575181157;
        Fri, 19 Jul 2019 15:26:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x13sm34024771pfn.6.2019.07.19.15.26.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 15:26:20 -0700 (PDT)
Date:   Fri, 19 Jul 2019 15:26:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2] etf: make printing of variable JSON friendly
Message-ID: <20190719152613.0751684e@hermes.lan>
In-Reply-To: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
References: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 14:40:43 -0700
Vedang Patel <vedang.patel@intel.com> wrote:

> In iproute2 txtime-assist series, it was pointed out that print_bool()
> should be used to print binary values. This is to make it JSON friendly.
> 
> So, make the corresponding changes in ETF.
> 
> Fixes: 8ccd49383cdc ("etf: Add skip_sock_check")
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  tc/q_etf.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tc/q_etf.c b/tc/q_etf.c
> index c2090589bc64..307c50eed48b 100644
> --- a/tc/q_etf.c
> +++ b/tc/q_etf.c
> @@ -176,12 +176,12 @@ static int etf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  		     get_clock_name(qopt->clockid));
>  
>  	print_uint(PRINT_ANY, "delta", "delta %d ", qopt->delta);
> -	print_string(PRINT_ANY, "offload", "offload %s ",
> -				(qopt->flags & TC_ETF_OFFLOAD_ON) ? "on" : "off");
> -	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
> -				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
> -	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
> -				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
> +	if (qopt->flags & TC_ETF_OFFLOAD_ON)
> +		print_bool(PRINT_ANY, "offload", "offload ", true);
> +	if (qopt->flags & TC_ETF_DEADLINE_MODE_ON)
> +		print_bool(PRINT_ANY, "deadline_mode", "deadline_mode ", true);
> +	if (qopt->flags & TC_ETF_SKIP_SOCK_CHECK)
> +		print_bool(PRINT_ANY, "skip_sock_check", "skip_sock_check", true);
>  
>  	return 0;
>  }

Thanks, but if you are only going to print json boolean if true, then a common
way to indicate that something is enabled is to use print_null().

Could you do that instead?
