Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2A75928
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfGYUxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:53:49 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:35305 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfGYUxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:53:49 -0400
Received: by mail-qk1-f169.google.com with SMTP id r21so37552159qke.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 13:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gbyAVxoDjO7ZCPhgKeEn39QgQ4E6Xw7YsugJjeQ9DCk=;
        b=XxJJkp7w1u2aNBNSg6DwpIe/N7y9x+2yRnVcUYTiw1t5wUdB1rJjdBNoChleMZBLB7
         w3yY+Dr1w6x7N93LDpfqKFa//74N8wxvq6knTQXoS8bnQr+cdl8EgzQMqQ4hA3OwnxOt
         8QunHUa1kjpGo3xLESp5BDW3cQ7R5xVdp/mQnu9+44in9Ew3Q/UftI4ucN22kX5yf4W+
         lV2o/iTQzaKcF41QYXaIencD9WD85qCz4AQhK7cvCYllP4/FUh/HQJASKoar8L535oXt
         fOpKHMik9wmSskF3la2EK3ms0IDybi37BknCnIHsJ5xPLE2ss9G28aUTX7ZsvJ8dEK/Z
         o2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gbyAVxoDjO7ZCPhgKeEn39QgQ4E6Xw7YsugJjeQ9DCk=;
        b=UPw5nZvV2uj84eGink1muq0qVusPduNklqv+0fnfgxSAmSHCfnvuJHik00Zu6jq/vq
         wJC36J2BUiJrd0viorvp+g2OR0QNxq+ZxjO7f1MkrpjpfcFaA8Tf6qQOK0k+e28v6zq/
         5vApXYZRKeSxqF2m4H1COEqcuF+K7lgM1IICqeMQQE+qpHbM0hLoOqjaQuxAADMq/MDf
         ajgIzk+/OXL+ZA3D4OlBRpK49ovDOLlaCffdP9UqFhu6qRooinZrH7QQ8oVVr/yJUsST
         7Pl+/69OwHk3QLciwaJ6vydRfMegqxXKtfh6kwlcdwg3NT0Ih0V/CUopDwRnoUhsJjPi
         OEAA==
X-Gm-Message-State: APjAAAWJ1som7O0ZhuhooH+1AzSeSY2yrmR8HjNd+VSn41pIogUnjxmn
        wztSmbtdy9c6l3kHLDbwlOQDOtlV8yg=
X-Google-Smtp-Source: APXvYqwfLa81NcS9hxBi+XKAMktdv0y8h9at63+PTNAl1lDEuiL8xv0gveb7MfZjRjCZ+OlGcQl+tg==
X-Received: by 2002:a37:a851:: with SMTP id r78mr6842462qke.120.1564088028637;
        Thu, 25 Jul 2019 13:53:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f25sm26610789qta.81.2019.07.25.13.53.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 13:53:48 -0700 (PDT)
Date:   Thu, 25 Jul 2019 13:53:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 9/9] Documentation: TLS: fix stat counters description
Message-ID: <20190725135344.45c44127@cakuba.netronome.com>
In-Reply-To: <20190725203618.11011-10-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
        <20190725203618.11011-10-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 20:36:52 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Add missing description of counters.
> Split tx_tls_encrypted counter into two, to give packets
> and bytes indications.
> 
> Fixes: f42c104f2ec9 ("Documentation: add TLS offload documentation")
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
