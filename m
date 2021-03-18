Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285FE34072A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhCRNsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhCRNsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:48:37 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13442C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:48:37 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id v3so4912660ilj.12
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OlLlW+4mzytmEF/KXfTW31rSHZGM6acYv3fG14fan0E=;
        b=KLbZT+fghqyIGxdjeoOx6qEXojl8VtwHacQoyTGfZaKH1jhk1DqOpBvuoJkMRWwQXW
         W0JzBvMxZ0tgnJsLgVJ9apIhD3pvKbHehSE8WRh1Mqyr8nH+ZFxecdkaikH+73OLuRru
         2HAOx7lx8UWjqnAvtmXdHUxFZpvrcmITBMxOb95CvjGRorDGUmMVFdqO6ZtRKQEFstdE
         9EtPDUagIlfTrp2BUMjJORH9+SxCocWKe4RM6JH5zeoob62DM4CKx2MLADa7lwQFwQCH
         4l02cuWD7OvqP6p0dbn9SiVwLeyCcvsvIKbnxeF/Kg6Ly7o6YPkTdcFoGVit2tPXAC+p
         mb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OlLlW+4mzytmEF/KXfTW31rSHZGM6acYv3fG14fan0E=;
        b=JY7GkdOPIv9wUl4yubsV15iEt4tmKsYwee1QL5Kf2NvoQrIAuoHobMLWx4dYD80u6q
         f4NZToRhu/PdPNG9HzPOvAHg6n590pPDSIvPZHy41mSGm3CxXg66AGWcCMqtSuWmxx2z
         laewviJ7Rr2+O/5XXBsLgBcSE4YIJ2Fp+PeIbOIAO8X2/ubF9EXJLVbEAGJOnBSv1g3L
         Arc3ZoWdZBXXFq7N4tgY4zLo2gk95Jo5LTT6nCijQtrQkfOnUA00JFq85/qePZyWtkMp
         VtipTvIklezjUtGg7ng3oL8QSjXEiT5orW56XYmIaCACOiXQDB8iGGjI2EArlwN+WVLB
         XHbw==
X-Gm-Message-State: AOAM533bdpAd78vp9uYY8sTT09qT4zItBpCplMjqZNklqw4g6FElWCNF
        mG7xDeWQrzU7D+Y8pugsHBxUd1DnlCyacl5e
X-Google-Smtp-Source: ABdhPJz5JoaYesVBXikWV7/axiHba/plc/4UerjwkwbMwFXAfJs3m7xSRY9lnJqzww82ljGaDrCvSw==
X-Received: by 2002:a92:4a07:: with SMTP id m7mr10486368ilf.51.1616075316336;
        Thu, 18 Mar 2021 06:48:36 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h2sm1033140ioj.30.2021.03.18.06.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 06:48:36 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>
From:   Alex Elder <elder@linaro.org>
Subject: Patch version tags
Message-ID: <83989a05-0491-bd1d-dc31-f963c3dd6096@linaro.org>
Date:   Thu, 18 Mar 2021 08:48:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple question.  Maybe it's been asked before.

Do you prefer "PATCH v2 net-next ..." or "PATCH net-next v2 ..."?

Both work.  Which is better?  Which makes more sense to you?

Thanks.

					-Alex
