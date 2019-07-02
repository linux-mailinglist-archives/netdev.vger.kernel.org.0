Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782545C7A9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 05:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfGBDSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 23:18:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35401 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbfGBDSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 23:18:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so1566860wml.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 20:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yUk5lbiQsQxduT1s/Hx1W3GMhf/dap8VWFQL6UPFK3k=;
        b=w1NuQhxEmufAGtUv1dL34P4aw9YN4kCLoygHzqfXfMik/rwOU0X3c/SvBOHByrqoqO
         VL277HiAzv+hXRzbaB3kELb3rIf3x3ShhmFhvAd2FRgXteteHIcS4Iiza6KLMfJX2R+F
         sGrr2nfA1xCwtf7YLgi1QFWWq8k9aBTrFkwsIeczUzpSbRHzaSne3CPg9ITwn6UtLPK4
         JaLdM1ZrlSSSn0CuL34UE7lkUfKvns3T122FA03JwS3KLWlcb+YY693O2zJs5rY9BkWK
         uj8DOYxlmHYQ86bekwQ/1vyztkWWL8y9LwfwmERE+DuYT10sScSQ83+t+U6CsvpwgVCT
         FJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yUk5lbiQsQxduT1s/Hx1W3GMhf/dap8VWFQL6UPFK3k=;
        b=Awej5x6bLKIvBW6HZ1tI+L1ueER4npNmYiXj85PRF8ibEzlNwsRXaFFuPgPW8uATz+
         50qAoOeY1HSFRHGAcPWy9BDFnMpVAkZAweQa4VI0XXmapzhh7JWooNnmw/5N/fzsbpVn
         FrS4eTsTgt1ZmFVXaQ3iL55/8EZC1jWfo1cwBDD2oDhCFKpNvW/8A1vHc0q2CacgDC8m
         aV2HnHZ+iCt1UUBRdy2VGapDxsrlcfr0tIffjQ+f+P+KSqEJ47ve9SZi2fOfNoSoECZs
         J2Eq2vhsF3Gg8+5lSQJBwUBbP03vVjn+sKS6r8iXJNMelFKjKzyyhy93WtpQHo6BykqL
         vdhA==
X-Gm-Message-State: APjAAAV3MSyAJWAVGCbSZPkNDNfudrWNxCBxpWMa51kIQpoDH2FS23jc
        MqA+XzgA1OUf1mc9CJkduTNpAw==
X-Google-Smtp-Source: APXvYqwgFDUYjuEy+gw/n00q8IqB4HGazwmuo7X5nw8roCikCofwqBvWGk6g3Yjn9p02APjINImyHg==
X-Received: by 2002:a7b:c776:: with SMTP id x22mr1365294wmk.55.1562037494229;
        Mon, 01 Jul 2019 20:18:14 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id 15sm1322645wmk.34.2019.07.01.20.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 20:18:13 -0700 (PDT)
Date:   Tue, 2 Jul 2019 06:18:10 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH 0/3, net-next, v2] net: netsec: Add XDP Support
Message-ID: <20190702031810.GA31493@apalos>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <20190701.192733.26575663343081553.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701.192733.26575663343081553.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David

[...]
> 
> Series applied, thanks.
> 
> I realize from the discussion on patch #3 there will be follow-ups to this.
Yea, small cosmetic changes. I'll send them shortly

Thanks
/Ilias
