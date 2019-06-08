Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C442139C68
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 12:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfFHKYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 06:24:20 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43431 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfFHKYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 06:24:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id w33so6309538edb.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 03:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4riSMHP5wUHrpmdeM33QciOXIgZdzlidR/XgwVK/1bQ=;
        b=k/ArZe5sCTXMzaNYaIKyUbrcfu60wYh8hOAXnJtyyBtCsnD3DXPOex8Dv+VxFRJWyX
         qFZMWt6YU/nu+vJXGjmCPUQhGMgFg6iAuE3R9qa9XDueS/uDq3EqaSgihHEjRWpqYfxA
         PL1b05zvW+MiJCmbAZRkweayrxxIWDLu0vMTQWkjuOyedb/ODECVdPSrvXaCYoZoT9PX
         Z7RkI0DVt6fregz11GI9UrllgTZTS+Hzkw14vmzxaXCAbChpZXZ2HH4OQyDi/julm2/P
         F+/vGEW9CVJWx+B4Qxsn73NkPL/PpzHNSc3HTVCMnmr0lDn62LtYb7jYiFPUnYkYAq0M
         LJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4riSMHP5wUHrpmdeM33QciOXIgZdzlidR/XgwVK/1bQ=;
        b=PFkGUvBE5I4lZK3DKf4SQ5BMm5rXqAT9IYfdut1b39POQEL4smwJzCwjFhZhYj8eEK
         d1rsyjIyQ802HR1qWeJ1MIUV3/w8s0+KGV17cca1BX4R5PF1a3J45H8GUpmy9zJJzFtz
         CQh8SVGoDXQhp8bMmrxw3IxTgwEGtCqM0VtKDJRiSKh1V3K4CiXPpgYRd6/3WjbBryAe
         BBrklS1oTyjxuyXhvUtHlRUxwPYTIy+zUojXNE8pxxYlCjXiZjaaueEFI9ZIJ3hYMhha
         /lM7LMiFdpLzBdMd74jqYEsUXX5Mw6KL18HedIIp5zPpxje/WUMpzUv6Wq2n4IljGdKV
         P1mw==
X-Gm-Message-State: APjAAAWrDkMyZaefMu1QtUFMAlxzOTR8GN9Umu7SMcUCkU909ZPkq0R/
        FwZ3EwXOoC0aZgsKZWuFBNM=
X-Google-Smtp-Source: APXvYqxZf2u6OJItOSJlZ5cIgYcPpjKQ0SUC0rUmxDURPsM3T5IABv/ji0+we0FcdNg9AYvNplA65w==
X-Received: by 2002:a50:b122:: with SMTP id k31mr42146301edd.204.1559989458285;
        Sat, 08 Jun 2019 03:24:18 -0700 (PDT)
Received: from ?IPv6:2a02:8084:601c:ef00:991d:267c:9ed8:7bbb? ([2a02:8084:601c:ef00:991d:267c:9ed8:7bbb])
        by smtp.gmail.com with ESMTPSA id f3sm817102ejc.15.2019.06.08.03.24.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 03:24:17 -0700 (PDT)
Subject: Re: [RFC v2 PATCH 4/5] seg6: Add sysctl limits for segment routing
 header
To:     Tom Herbert <tom@herbertland.com>, davem@davemloft.net,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <1559933708-13947-5-git-send-email-tom@quantonium.net>
From:   David Lebrun <dav.lebrun@gmail.com>
Message-ID: <673e5177-eaa2-9b5f-f750-4e5106eda5ea@gmail.com>
Date:   Sat, 8 Jun 2019 11:24:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-5-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
> +		.procname	= "max_srh_tlvs_length",

Should this be "max_srh_opts_length" to be consistent with the rest of 
the naming ?
