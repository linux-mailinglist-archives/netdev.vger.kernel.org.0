Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AF514275
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfEEVRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:17:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35657 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEEVRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:17:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so5321208plp.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 14:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KUBY6RsAaByn3L+kbxRVaeZ3H1x5XBUcPZnsZgkcnak=;
        b=RrqUWxML6cSYYrgGfn7jMOlJkjgMpkg3mR45OJCJ+cmwhVu0L2jfn8SIWJqkTrLSxu
         RQ5X0E3q3TCL8zos+piebpQjwwX7gMhw7Zs3KBrxsgDVQOHIqYqeQfpf7nU6GK8qjXJL
         njeUsdyunfpZW4bHCJ56cLtH2xDFhKYD7T55QctIR7D0jQYMe1F92LJK3m1QkbOWcQbg
         6XdhcLZ1rd0xzbsDbLv34U47HDks5o3ME1F7bILqsCKhSi7gbT1S3L4kMTuYo0UJEvIV
         M7T5ceD64YkVqexP46FZld8/QVuKDE6d8tSC4qocpCfFtQiH3WkUVMu1ba9m/en5vgy4
         t5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KUBY6RsAaByn3L+kbxRVaeZ3H1x5XBUcPZnsZgkcnak=;
        b=ku2hrB+XpkqnBE7mutJ/6EeKMILqJVnqR9VYcuTU9mliASOWOOmremG6XYcfu1YLlc
         EFZyk3BPfaANVHc2fZqc/iPkw4IsU/Ws2qCwfYlHGoBDhKM3b6AHpEK41IeRaiKuMyWd
         8ciZEta9Vk+K8/NPPDczrKxbt6l2dmPL8jmM7ph1YNiB1pVr3u0m3A6iPVXHieKPf7fY
         E40h3PBzb0sxc6OhWFci5tDzaGnEFJ3FWyftALlOj6k9jKaB/anMWAXTzuF+m818yCm0
         WLiTA2nlhOoDlok+TsonhqprY574vcnOe39UzZpmZPlAG+3GKR73tu5O/37jAKb5UoZO
         qV9w==
X-Gm-Message-State: APjAAAWU+2tcBNn9p6ulFJLt0okh/07uecx8LcjuA99ze+KkQvmZlZpx
        bqEBPiwkf4LOGPCipyEIRKhKakq7
X-Google-Smtp-Source: APXvYqzMMJu4eXtZ3rtNHDIk0DSWEECbu/07VEmXQC8P3rJBs9KfWMs2W1G5jwz9pFyfS3XEgWZGMw==
X-Received: by 2002:a17:902:84:: with SMTP id a4mr27964172pla.210.1557091030711;
        Sun, 05 May 2019 14:17:10 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 6sm12358700pfd.85.2019.05.05.14.17.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:17:10 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] net: dsa: lantiq: Allow special tags only on CPU
 port
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20190505211517.25237-1-hauke@hauke-m.de>
 <20190505211517.25237-2-hauke@hauke-m.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ec7f8b46-c012-665b-9c05-eaf180b7f379@gmail.com>
Date:   Sun, 5 May 2019 14:17:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505211517.25237-2-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 2:15 PM, Hauke Mehrtens wrote:
> Allow the special tag in ingress only on the CPU port and not on all
> ports. A packet with a special tag could circumvent the hardware
> forwarding and should only be allowed on the CPU port where Linux
> controls the port.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Does this warrant a Fixes: tag so it gets backported to -stable trees?
-- 
Florian
