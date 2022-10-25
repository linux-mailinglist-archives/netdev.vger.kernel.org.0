Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8885460CAC0
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiJYLSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiJYLSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:18:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BF111E471
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:18:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o4so11975556wrq.6
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlv9YpH+89iDQBPgSgeaqKToqtOHPB/QKXHLgRQ2ZZ4=;
        b=Vt2mwNa80CIu3r9jTO25MeE49mThPGR2K+9AfrsI+DrTkdfu/FQj8HBvooXjubPhim
         CTLZYbnw+m6fUjr+I884vav3ZNv8Ni3ycUQfnloHNqdzv0XGib9fmPC0ewF+7/RU/bjr
         2o/1bA3xBIzza4nCgaPCtlzqMps19IVR9XiFHf2rMGrZgJAOzXLtsRVl5+ENGOwJrHxB
         IbqBYNlF/3InNyTNKj1n9+9xyxMRxDsHDb2/34Fb25CXM3M9/n/56chS6wCCMngMNw5U
         roLlYQ6AjTgOr2HLQmPr6tr3s6Av1zZMyqYdQjWHdcxcTG8yW70LBSnPYqenubq2qm2+
         obhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mlv9YpH+89iDQBPgSgeaqKToqtOHPB/QKXHLgRQ2ZZ4=;
        b=sHvGnHkmDC02uCbrwm4Q11vQzaLQMa4zDv08UI6TObourNPluH8txGSL0b6ENatRqI
         jE+bi8iEIG+NAtFzx8aDNydNGnlFbq6UZ29blWCez2oB0i2yzqp04+JviOiRLgmFVszS
         kEDVa7k+/1jvsYQjRANwoMTQ0+doiOGv9bV07aUAD29CKdJ8wK839p6qShh9YVUT79Xv
         9pc/i3//VE+MvemuHlLZI2Y6DrVvxmDOqc3/HhnOrhTtzYfDWbMjD+oVyLZiQ8wgquzg
         ZfhYFDXjBJnim569gTDGOkkguT+7FoAAWuzyTOIcI7MeHtQKag7WK9HA9nUNdVZUyEti
         svFA==
X-Gm-Message-State: ACrzQf3it0oU8gMdojv2mZOJ0KhzNYr9otf8cn2grqj0IELe/ITvL6Ae
        35DZWbQ5/8vZlbM6fmqMq/k8gm/e418=
X-Google-Smtp-Source: AMsMyM6v+NVVGizVUy8YGMVx/pRApKc2VjDQslJTXhUiP3Ax4ywUlep1sXUOIX3m8xQtt5L9kd2MJQ==
X-Received: by 2002:a5d:64e2:0:b0:22e:7060:b4a7 with SMTP id g2-20020a5d64e2000000b0022e7060b4a7mr23784283wri.129.1666696682266;
        Tue, 25 Oct 2022 04:18:02 -0700 (PDT)
Received: from [192.168.0.121] (buscust41-118.static.cytanet.com.cy. [212.31.107.118])
        by smtp.googlemail.com with ESMTPSA id k3-20020a05600c1c8300b003c6b7f5567csm1449237wms.0.2022.10.25.04.18.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 04:18:01 -0700 (PDT)
Message-ID: <2528510b-3463-8a8b-25c2-9402a8a78fcd@gmail.com>
Date:   Tue, 25 Oct 2022 14:18:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   George Shuklin <george.shuklin@gmail.com>
Subject: Bug in netlink monitor
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found that if veth interface is created in a namespace using netns 
option for ip, no events are logged in `ip monitor all-nsid`.

Steps to reproduce:


(console1)

ip monitor all-nsid


(console 2)

ip net add foobar

ip link add netns foobar type veth


Expected results:

Output in `ip monitor`. Actual result: no output, (but there are two new 
veth interaces in foobar namespace).

Additional observation: namespace 'foobar' does not have id in output of 
`ip net`:

# ip net
foobar
test (id: 0)
test2 (id: 1)

