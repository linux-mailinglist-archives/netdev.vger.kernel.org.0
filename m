Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8989EA61C
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJ3WYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:24:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38859 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfJ3WYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:24:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id w8so1667933plq.5
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X9VyLMUyQILhFfntho48j06gllx/3pzlvZcOIZ17uA8=;
        b=Z+HsTTXQWb1sZMAyImyoxeuRZXlKFBkNfoiKVsjyv3KNHYHsA2k5DhngKcwHtS/Ywx
         8SggQK9+wh+50zXXxCiNrRPWQ5vGBOUKaISNkyFcyP5anJL4IYqFQcFat/G8fDUP8lc4
         qQ7yqPLEjN2YNEh9skPRlnNmaDmwHr6bdIOUfRymwL6SIlsswSWUSLLqTVw9rHCCgp1W
         ISii6pLNprUuXJAAj7hQ18IIudt1jLA/GAWE41S5EuHzXHyDbmTzjCxGJnKOBhGQ2ejR
         KfnQwmHUl6hsw/0ff5MJxq47gnfRDM4bChYeOglnoJt/LzRPDd8nMGpW6XCgAY5jktYn
         CoJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X9VyLMUyQILhFfntho48j06gllx/3pzlvZcOIZ17uA8=;
        b=Ny3wxuwddZS74mllJcfJMT8jGX6pmQsLLb7eZC0qyD1p1sR4w73mQ8UzBQ9O+COnME
         0/lWSb/68p/gckhvgtKfn8ou+gd9Iyqs1ekGCH33iLOsYuRx9vIDXh+w2ZcyTY2jIKC3
         ry6etqe3QsxeYdzKv9EeicOIbgKNzxVo9gTMQMe7H+zXRHW9WFcgsnCdaPTvofZSCOqV
         ogyrK1KwdfoRTIhfSDv1tU+kNzwE7Px24ZeO0w80Oq4WTF73DMbuaWrJGykw2cxMXopO
         c3xeHVyWh7hDY+3BrWBDCoBhhs9VNNLgSckwHpeaSdWZ9j4EyJGSTVFLigl7cXl97SU1
         PRhA==
X-Gm-Message-State: APjAAAWBTmGIH6vf8x9QiCLlehhvJWIg1oXevepw3aeYKPsn/81KXCLL
        JxJ35aBUlOt7fwl2H1viy/kPJ2ydfbUNCw==
X-Google-Smtp-Source: APXvYqwLvbvxj/wkMVtsAWdfWXGZ+pj9058IFSWIXjHdH88QWhJd2+ntrjkCVPvvXz1QL9N+6/IzwQ==
X-Received: by 2002:a17:902:a5c2:: with SMTP id t2mr2443250plq.258.1572474271752;
        Wed, 30 Oct 2019 15:24:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q2sm978057pfh.34.2019.10.30.15.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 15:24:31 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:24:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH 1/3] net: Support querying specific VF properties
Message-ID: <20191030152429.2b4299d3@hermes.lan>
In-Reply-To: <1572462854-26188-2-git-send-email-lariel@mellanox.com>
References: <1572462854-26188-1-git-send-email-lariel@mellanox.com>
        <1572462854-26188-2-git-send-email-lariel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 19:14:47 +0000
Ariel Levkovich <lariel@mellanox.com> wrote:

> +	int vf_ext = (ext_filter_mask & RTEXT_FILTER_VF_EXT) && (vf >= 0);

This looks like a boolean.
