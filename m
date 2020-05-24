Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCE21E02A1
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 21:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgEXTyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 15:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387992AbgEXTyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 15:54:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6BCC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 12:54:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id l25so13442832edj.4
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 12:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=4XTDzJ34X9a9+ksm42IrnGVtEC+x0GPlWxQYC2o3YCY=;
        b=S7d+ezbfJ5elG17pokmdcunUavWfSI/RXSydJabpbqhlbeGpbMDzRpF4v1JrsPvQff
         eW71za/EmzYnykVuFoIfepYzo2q5+mRZBBo+X1yPG9AlHayLXEKiP7dRiX0dKTlxNXGA
         sapWe6EI7GwcvODAJPWTsxfBKTN370ae2q5C1+35eog5/Py4NqBI8czTMVNTT4kkoB+u
         BTlY20dn+tSu+OEFju2mTQo2p4eCG+DQx4tyjVBwLtgKPruQk3MTo1Ec+J3qrdwf5a4y
         zT+A5a5MLRMvIFdZiZceZY1c81gD6h6osWr7ZgCVcS/0q9/0kIsNW0UOZruvLXR6vsPs
         ze0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=4XTDzJ34X9a9+ksm42IrnGVtEC+x0GPlWxQYC2o3YCY=;
        b=hyW7fpQ4W5fN4oSUaim6hLxnEbPM82KTh9vBJ5tnOoU+PWCdopXEcbiPJwO2blQkPb
         gj6EZouV5VgTnok6WiqICt/qM/yuTSS9a6tyG2nxNnwodKHfOVueRHvxu56HQG3gmFIU
         UR6dqN5pp9qIr8gPXkjVgXnZQ5/juqVEmij3lhbnUZa7OBr/jFXwb4Gj5kGBE6oliNLz
         K3EMJHHc+YWsBhaE57iE04E0VpcTYAbeU8mK6XupnlIWiL28f1cTM+gJU6UdpU6ceo8+
         9Q6uaBsTbsK8OkS1AP+4nR9cO9kLpViUsCfORZEOKtud00YjRwiJAezSDDcFI+k5HKZf
         t65w==
X-Gm-Message-State: AOAM531Tzphiu0IYSoz75/GPd0Wo6PHfXSR5d5li0rQDV8lanVS9qHpL
        iXccbPgeDc5K+wNmsiHl+bT3tuVn
X-Google-Smtp-Source: ABdhPJw/vQmfwY2xM1FP1cTTxAmuIXV2v+Bj+ja2Yj5gYBMS63TcYWE6pvenlt4lrKq+c0ecGbDdrg==
X-Received: by 2002:aa7:d590:: with SMTP id r16mr11848272edq.304.1590350058936;
        Sun, 24 May 2020 12:54:18 -0700 (PDT)
Received: from [192.168.1.99] (c40-106.icpnet.pl. [62.21.40.106])
        by smtp.gmail.com with ESMTPSA id s19sm13978604eja.91.2020.05.24.12.54.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 12:54:18 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   =?UTF-8?Q?=c5=81ukasz_Kalisz?= <chemiczny.kali@gmail.com>
Subject: 8111F issue
Message-ID: <93361356-3700-5d3e-34d0-559421e81532@gmail.com>
Date:   Sun, 24 May 2020 21:54:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: pl-PL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello



I have been using several boards with reraltek ethernet

and everyone was just working

now I got board wirh 8111F (previous working was 8111E) and I'm loosing 
connection once a week or even earlier

I tried using 8169 and 8168 modules (gentoo, 4.9.120 kernel atm)


Is there something I do wrong about it?

Appretiate for any help


Lucas

