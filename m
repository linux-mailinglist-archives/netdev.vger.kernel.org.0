Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008F221640B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 04:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgGGC2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 22:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGGC2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 22:28:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1B3C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 19:28:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so44970688ejd.13
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 19:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e3BAvGHyT5vul4bkvhHx+liZG66MEtRjIuz8mZ36jJs=;
        b=kviW74H4Lu4gPaoNGy3XeSTZ4meXzi0hQw3BPwR61GAAtD3pZ6sMYiqZ4Rr9JQHVXD
         e03vwQerso/FkO1O3QQX7S2pbXoZ1NWeo4MtDHoLQPPuGBTLA+gTXiFmvpf45/KM6xfl
         CQAA+gN1lDVl7z//FnTv5suvNZ8RnArjmhHWw/e6tcTkN+gsbI+t7znTL/2nB2CJwBNE
         mQThSleqSMAt4NPneQpK5qnFpbx8XRTbCH6og9PhraYKPtvQ6faNpgNpiCY/sksDlqqE
         McAF4O2hT1jZUxYMkIkgjo6sniQY+NoJeS4OFTBc2WXq30PnOlXEU+CLmSrc67hqHcmG
         FqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e3BAvGHyT5vul4bkvhHx+liZG66MEtRjIuz8mZ36jJs=;
        b=OEGjtoP0mTz1Wksijoa6m5H9P9AmYvruZfbIdFVkfWNZ6NER7dMZgZQRPUcvSvmtqx
         qXMnkC+L79luXu7MsMpSDPwFDedOpOCtNt/OeEqfSvcqlOkUQy6KFZYBmPrRt9e8i1fF
         oEyv/ifWi6AoZgVICZuLLE+NNNDmo9DA/0NmofEqxt8oFxSfggyVpLmUGe5TpszNiaq9
         uRsvhiep6fKa/qrPSBq2sgKblDIjd9WTIsQHkgOZiu0cLehwUIGHkugRzg3W0GswLRDf
         hnH+W5PdIwB7OvH4VelFy1E/GKw8OYKVsfLqZtp/gWmO9nNC3FsUFQmgvf/ZmjW/z6ev
         fM7g==
X-Gm-Message-State: AOAM530kk1V7T6MHLOidk7fKXKjdDcFz5ty4X3dUCB5zDJ6ZiB1seNkk
        AMs+Oe6yUb+WJRoMtws0pV8cfVke
X-Google-Smtp-Source: ABdhPJyeHOnHO60jjA1jee1+y4PSXa7QQST2rLQiL3scsZw797HHeuTAlcAgS8yTpFst+AVrtf8Png==
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr45731187ejy.138.1594088932229;
        Mon, 06 Jul 2020 19:28:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id rv16sm17503231ejb.60.2020.07.06.19.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 19:28:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/7] net: phy: at803x: Avoid comparison is
 always false warning
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200707014939.938621-1-andrew@lunn.ch>
 <20200707014939.938621-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <842a4462-26c4-72c0-4427-2f44ba46b722@gmail.com>
Date:   Mon, 6 Jul 2020 19:28:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707014939.938621-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2020 6:49 PM, Andrew Lunn wrote:
> By placing the GENMASK value into an unsigned int and then passing it
> to PREF_FIELD, the type is reduces down from ULL. Given the reduced
> size of the type, the range checks in PREP_FAIL() are always true, and
> -Wtype-limits then gives a warning.
> 
> By skipping the intermediate variable, the warning can be avoided.
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviwed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
