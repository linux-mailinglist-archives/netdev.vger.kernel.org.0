Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B025E64A9
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 18:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfJ0RqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 13:46:12 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36998 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfJ0RqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 13:46:12 -0400
Received: by mail-ot1-f68.google.com with SMTP id 53so5284730otv.4;
        Sun, 27 Oct 2019 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xEy3TN5x5/gYla+irAZsZ6AR5hkYO/R9cAnyhZadJDg=;
        b=LPwzPvB9k8mqey+YGpTQ6S36Qx0exXD+8AzvsgLrNAkE4olYCyufUYCuIJzgVuVhV/
         HwvmGYLs9LY5M2G/gFdj3Ici4IwwyGLxZSPTJLThK6vlOC4srQV6f1HdOzdwgSYXrmxK
         xoDuJjPCO26ElWRtrNIB2OOyDdn5hXgyG20ajGWQY0qjWSmTOs2BtQU3DNPa3t+sfHgO
         fqckWg+s7Wr/8flPny/8e6OUka30bRmd5+IqpN3iayYU0RwvkklXseFo0HPG2j2FXKlL
         96GAsYeKNPnJKXjKgtnm1r5/SkAxGMeq9aF57APXdkuhAId5wFuIxcG9aFl0zaeIiZbb
         80mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xEy3TN5x5/gYla+irAZsZ6AR5hkYO/R9cAnyhZadJDg=;
        b=e/abgiP6qBAxrRgCSt7Vh+FmjlKQ4cfxGpVTcpkLb8qHCCO/elGYKtZ6MPglVKwtwN
         rnn6ynudI2t9aUn4OXwnDC396xKjOVtB1V+VpO1VKxzTXrzenso/6GGO/jQBPPS/Y0ow
         QeXp16UrYdOkPj4GSuJQKZ98VcX/6R80IZudyKmhDXLk33c7KE7FlZGWo1ACnUHyeJV/
         4v4xqNfLnQyMpZkYdOPjIezJvANOxajn+fp8dxO7t/TREtzd2LxcKyIDkKq6PouhG+cL
         NdbzJQ6/yDhozaCBUjHjdWkOJC5M4Lv59cXitCaktuPP3MhYnghEWMSz0LZQ4KhZwipM
         +Z3Q==
X-Gm-Message-State: APjAAAWlWmpANi79urkI3gWnEIbnZLcYQkwyLse1MH+WwrTeAGsZ93ET
        ryBMsBvn0MFyVBQ1lbOgCxA=
X-Google-Smtp-Source: APXvYqzoaHRM3IGVKcPhpxaHhfefPQI2rna6kX88/tP6OsaCMilIEWouzS52etJYBw5VZ+iYnNbTMQ==
X-Received: by 2002:a9d:7d09:: with SMTP id v9mr10685593otn.292.1572198371402;
        Sun, 27 Oct 2019 10:46:11 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y18sm2793129oto.2.2019.10.27.10.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Oct 2019 10:46:10 -0700 (PDT)
Subject: Re: [PATCH] net: wireless: realtek: rtlwifi: rtl8192c:Drop condition
 with no effect
To:     Saurav Girepunje <saurav.girepunje@gmail.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
References: <20191027062255.GA9362@saurav>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4d2b5e56-48ba-4af5-e7c6-b6171210cb32@lwfinger.net>
Date:   Sun, 27 Oct 2019 12:46:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191027062255.GA9362@saurav>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/19 1:23 AM, Saurav Girepunje wrote:
> As the "else if" and "else" branch body are identical the condition
> has no effect. So drop the "else if" condition.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> ---

The patch is OK; however, the subject should be: rtlwifi: rtl8192c-common: Drop ...

We do not use the directory tree in the subject. By convention, it is the driver 
directory and the driver name. It is common for the driver name to match that of 
the top-level directory, but not in this case.

Thanks,

Larry
