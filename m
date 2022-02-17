Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B886F4B958A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiBQBhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:37:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiBQBhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:37:04 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9298712E74B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:36:51 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id x24so4348239oie.9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Tq4RXYpfO2aLSB8k+hi7rM4F94Nmon+w5MsB+fGDnoY=;
        b=anyOhrwlqC5RNcOrrX7dtX5ns7A12S2bNws/JuNMHcKpMuQXt8DnImjlP+bk1AlvAN
         /1oJ5UatvRbzytw4Y4Qf3W15x273fJbBSQBVJ3t5eocuF4rARy34WrDNTNIMmr3ZiKMK
         uN9I6vOhbsHju4U+JZGW1d1t5tX7x9yiot2LPQz4kVWJydGHhwyZKtoCbRzGxrjsUmpe
         TtIiRBScQR2lSs/oxJn6kGv4Tkeus7MlctfHLkkRgp4IZowruFP8mMl5y/p2q+i64DjY
         PPcqeE/AcOZC2FLU4i0odSAnOSJ+1k9+89Ov6u4hDwyuYasEzKJ03GPX8UwS/wAMXZIR
         C6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Tq4RXYpfO2aLSB8k+hi7rM4F94Nmon+w5MsB+fGDnoY=;
        b=ZnIXpILFiv7cUCGfp3ea4bk1h/dCE/cSSPFJ3ytpt8qG5nCxanA+q5/MuiFV7nRpyp
         kIUckM8aDkTE9ig8ck9ERwvMzpr0ZmsAUC0KzpjuHLUM2o597O69ZeUHlRPiuwGV2X9L
         4BDDL+nKhgBW4OQ/YvgxqR14SZ5MVNA46DjLoXcQwaFFscNjv7Hk5P6flwka9n71WFhV
         tzaqOR4iHyUTd3DxuPSRQVTwOexXfTPOu47JAKiX2Q4scIbBymSI8ummHtAqUlcXkRA8
         EyyP50i6fgdOOE5KCfknms7nJNHe3EGU2GoSSbwreuLHDR72fAirBs4ix0sW3m8tXU7o
         pt/w==
X-Gm-Message-State: AOAM531zmxQREXY1s/XQ+koiJC4kgWqMmQoYWZay+ZAtMZDTlrMj1XJj
        2Pv0bCXC8ox2zAM3naGk/WY=
X-Google-Smtp-Source: ABdhPJyR1DWq8wALVUHlzGO6nXksW8izzJzn8u6XB0+w4W96YY3GbIdG922EWqBMwme2y1g/OOTLGA==
X-Received: by 2002:a05:6808:f0a:b0:2ce:2765:1112 with SMTP id m10-20020a0568080f0a00b002ce27651112mr1904835oiw.137.1645061810984;
        Wed, 16 Feb 2022 17:36:50 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:7844:9da9:9581:42ec? ([2601:282:800:dc80:7844:9da9:9581:42ec])
        by smtp.googlemail.com with ESMTPSA id l22sm15976630otj.44.2022.02.16.17.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 17:36:50 -0800 (PST)
Message-ID: <cc2e5a64-b53e-b501-4a08-92e087d52dda@gmail.com>
Date:   Wed, 16 Feb 2022 18:36:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
 <20220216080838.158054-6-liuhangbin@gmail.com>
 <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com> <Yg2kGkGKRTVXObYh@Laptop-X1>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <Yg2kGkGKRTVXObYh@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 6:25 PM, Hangbin Liu wrote:
 > For Bonding I think yes. Bonding has disallowed to config via
module_param.
> But there are still users using sysfs for bonding configuration.
> 
> Jay, Veaceslav, please correct me if you think we can stop using sysfs.
> 

new features, new API only?
