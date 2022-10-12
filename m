Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D5C5FC80C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJLPPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJLPO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:14:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6267CE00D
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:14:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b12so2785350edd.6
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJ++cbZT1GQzcKkN54BOhV7muiCQDnF4CoMQA5s9ysQ=;
        b=S1UtZnd2tdB+a5PXbVodnKXWsutQqYUr5VBM58AjcjhbjfTgtIhmVALjjqCw1fqRc1
         vE81XHq3/VTvpp1kr+K/JeJjHETVGzX7sK+Ht8+713sxQljFksxFxFKq7vJw6ROZ4uls
         hfAlMmOJjcLCSWcBnH33LssWpjWaP0nyLj5ISq9Gwih8CxR8K2z2Wn0MlofDxBKTYHok
         +zhzoOoF0bpQqPKPmD7sbkvUvH5Nvq31BTHapAIq39ViPOd//EjxYDH90n+yiKIg8n1O
         qZz8GPCcCrI66Ca8cjezsgpsyAIbu0TCNCn0hpZAeIo8guIlJZqPeD0YNL94kcN8BIcj
         BkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJ++cbZT1GQzcKkN54BOhV7muiCQDnF4CoMQA5s9ysQ=;
        b=Pm0jekxJLTUu9nVQsfhNwAHvs+k2rwqpH6Tz8TPhL5EKEFK5Uo3vzr9+KuL3HcU9MH
         BSDgJaYxpjABAYF9qP3l7BJx7gdfih7/qGzs77M10ZMyuNcIba/UcsFWBsUQfVBH/7zZ
         NGnKeqBJl2h/c+mxUccFtDK3APby1GIKkfnhwIX5mK+xFLYMErOnF5GPRGkUKRNJif+s
         XiwkanI0+EXkD2aisvPzXCeh38y3wnDk0tHoCANSHFwcwbwJiUshHZOVNzBYlm7VDu2j
         aVP3pi7EMmOCeY1lSSEIoSCmkxPDT9OiAUIFhoB6bzJbXvcTPOQx+cUssySR53iKSR63
         GSLw==
X-Gm-Message-State: ACrzQf1CA+a+dmLxJ61TrLWGKGdrZHOXSCe5AlAcl1sYX6IRdylgkdEC
        iTdXSfmROwHcOQzZtz3rE4M8tg==
X-Google-Smtp-Source: AMsMyM6274U9CSV9jS9j4sSiJo7SJDRlLjGDU/QLOYECQpB4iP3Nz6Ppvc0kLlWdLIaO1R7n8GYAww==
X-Received: by 2002:a05:6402:28ca:b0:43b:5235:f325 with SMTP id ef10-20020a05640228ca00b0043b5235f325mr27711161edb.320.1665587688434;
        Wed, 12 Oct 2022 08:14:48 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906058a00b0073ddd36ba8csm1378221ejn.145.2022.10.12.08.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 08:14:47 -0700 (PDT)
Date:   Wed, 12 Oct 2022 17:14:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 6/6] ptp_ocp: implement DPLL ops
Message-ID: <Y0bZ5nUGC09tX443@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-7-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010011804.23716-7-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 10, 2022 at 03:18:04AM CEST, vfedorenko@novek.ru wrote:
>From: Vadim Fedorenko <vadfed@fb.com>

[...]

>+static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);

Avoid cast from (void *), not needed. (I also mentioned this in RFCv2).


>+	int sync;
>+
>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>+	return sync;
>+}
>+

[...]
