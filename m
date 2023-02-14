Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C94696138
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjBNKoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjBNKnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:43:51 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB40279A3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:42:35 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h16so15110741wrz.12
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oyIHCsDRjxl+FvpGNFC/9O4b2F9KKZHOJA3U8YsY6Bs=;
        b=iFAhrvM6hsmj4VjsiEg9F27yFWdmIsOnUi9jZ2YDZK6hsnaqLrL4joovNY6pZRG0Kg
         Y9vFZRvkDdIi7fKjAAj+UIcldqHwiJp/v7GGREsp1XQHz8nAj7bxi3WanNiY08by77Ye
         MF/PMkM6gIpN7IcnKXVKfh97vKVYdmiJSUGukmsXIgrmG8hvAQVIoNIT9Ax4jKfCZMZY
         +NJoEc0ki8qTT5iItifyI24LO4I+TnBiSmEyjBiONqW5+zL5avBFioxxvhkwb8CKssgt
         AZUS2TjIiyWj8EtITbYhakBqiFDl4TVqSi97xLr0fdncQohN45DH6dXPqU5nNG5+9ZCG
         v8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oyIHCsDRjxl+FvpGNFC/9O4b2F9KKZHOJA3U8YsY6Bs=;
        b=aeUHKDNfT2qI7ucNt7fZOHtMJTlc8JzQLJRqJjG3d6cWObZrbtqrkJGmYtMq12NFTw
         QYQCehj7qlcJU88mg6bdVVbtWppyChfKilsKQZ74gwUIG+a4C5SXstNWPoCE7YtOwSDO
         iuL7geCKZVUwIALBIigS1GmLicsDq/U4JDuPmi/tbdFMJy9hWc4ccfWR5YIigqszZoul
         VrD2Xz9BLffMsGYYcX74n4PATlMwxAfNO0uTwZKztr/0HAe+lXY0iuUA5Lb9M9kJuo7s
         dg8sJJlonlBlbfUVeIdCLASA+pr6Bl0m5IB7YXadIfm9cJXY696suSXIjHdoKNku3LxJ
         W64Q==
X-Gm-Message-State: AO0yUKVdJRDmhYqG5Rf5MbNIQz8CvYhRVUQ3Qgk+tct57sl7/qCuzPuK
        lBWQY4yR4/cipddtSIGq3ll7hw==
X-Google-Smtp-Source: AK7set9zC+gBsYjKd7WcdpNT91b5/JanqxCcgqQY1yZnolG/xil7/6KRFVKyI+YkbVMzFgxNyWAtGQ==
X-Received: by 2002:adf:fd07:0:b0:2c3:dbe0:58b8 with SMTP id e7-20020adffd07000000b002c3dbe058b8mr1885965wrr.41.1676371352854;
        Tue, 14 Feb 2023 02:42:32 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id x8-20020adfdd88000000b002c5691f13eesm723130wrl.50.2023.02.14.02.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 02:42:32 -0800 (PST)
Message-ID: <e70ac74a-c5b6-798d-d7ef-9cec432313f4@linaro.org>
Date:   Tue, 14 Feb 2023 11:42:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next V4] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Content-Language: en-US
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20230214103611.3599624-1-sarath.babu.naidu.gaddam@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230214103611.3599624-1-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 11:36, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.

I don't see any conversion here.

Best regards,
Krzysztof

