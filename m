Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E828B2D1A8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfE1WpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:45:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43693 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfE1WpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 18:45:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so222195qtj.10
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 15:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ItHlkUulkyp7p4gO4Xdx15+a3r1hxGp0OmKk82+bD2c=;
        b=YgpY4MEAudD44KMFtlH9S3gXEAmctPEXr9MLS2Wv54uKePKhH80mXQeAIRDpcqtsYl
         n8PJ+Z6zWnyhtPKG6sIOVXm2KlqviAUEwL50O75fBGcxXvbq4Q4jVoP+ACG300sYupm0
         PtfIVxtnarUQd8VWmDER/zARsVK/05pdlpLjsJdqqmAXL+wNyr58jWZqANxZZDnapjeJ
         ZDp2OLmvRl7mclyvE2CAUhsZxgNrplTPjO8QB0iFkCoKBbbqWDa4KNefAt5KSw9bGaue
         PmZzxnEcwABhVQrMc6rgoVKTvNGKxUQj04hdvjMVAq21pxPxwGHlSwM+K+UP6g92EscO
         NCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ItHlkUulkyp7p4gO4Xdx15+a3r1hxGp0OmKk82+bD2c=;
        b=c9kW3ur7HjkZhrDkARdEoIgu1JAd/BwaxPTl0iFWYXmvEyWxKUbAkg7JIoo9NJBNlB
         aMHdx85sOpwkgMNIvS6ZfmbFEUx2P44yXwbYrw9W1EyIFxTEKBlp3KDjXnqWRPJMILsN
         mbNrWHtg5QpODNXqPv8rfOIwdqObGMzDPprrXdQYFjpG09qsS3WS7FWs7O3XXWv3742o
         E/QviBRHyVmEem8FFhBs9PMro9bIJWkn0MUb0hMHpOPUk/svN2DbmieZ5CRyCkvfrMv1
         XSOdYIE7JOjGp9Vn43xogmEBLyk2Xy/DWp/EZDkYlwvZn2JW1UK/PhyhNDZnax6pCmiC
         f3kw==
X-Gm-Message-State: APjAAAWVkz3VvJ1cPTnxFea74A4ns4/1evBaprpJVWyQDh0xhBXqQ6jS
        3J6msKBaS90lFjTrb9jn3V3UfA==
X-Google-Smtp-Source: APXvYqxVyissAjCECaaOzVDFHMDpIwSpjYVyFDqQHoqD3LGEr4ZP7QQyxBJS0GBuotNDdKzv9yNZew==
X-Received: by 2002:ac8:2291:: with SMTP id f17mr48099014qta.51.1559083515532;
        Tue, 28 May 2019 15:45:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k127sm5195875qkb.96.2019.05.28.15.45.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 15:45:15 -0700 (PDT)
Date:   Tue, 28 May 2019 15:45:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, intel-wired-lan@lists.osuosl.org,
        vinicius.gomes@intel.com, l@dorileo.org
Subject: Re: [PATCH net-next v1 3/7] taprio: Add the skeleton to enable
 hardware offloading
Message-ID: <20190528154510.41b50723@cakuba.netronome.com>
In-Reply-To: <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
        <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 10:46:44 -0700, Vedang Patel wrote:
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> This adds the UAPI and the core bits necessary for userspace to
> request hardware offloading to be enabled.
> 
> The future commits will enable hybrid or full offloading for taprio. This
> commit sets up the infrastructure to enable it via the netlink interface.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>

Other qdiscs offload by default, this offload-level selection here is a
little bit inconsistent with that :(

> @@ -731,6 +857,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	if (err < 0)
>  		return err;
>  
> +	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
> +		offload_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);

You should make sure user doesn't set unknown bits.  Otherwise using
other bits will not be possible in the future.

>  	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
>  	if (!new_admin) {
>  		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
