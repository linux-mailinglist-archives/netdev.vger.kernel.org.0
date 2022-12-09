Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2641E648AA0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLIWN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLIWNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:13:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A906F488;
        Fri,  9 Dec 2022 14:13:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id vp12so14584782ejc.8;
        Fri, 09 Dec 2022 14:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=El9vP6v9P5qhfX+EX/IA3Nr9ZJrWr13ab3q+0KHTw94=;
        b=dzhcuDIWq2f8putbGDKCuhc6i6MZjyxtNvY5+rF5O8O+XbZKc0tJdaM/obmF4zoW2n
         ov8qs+fA46RJ7jiagELkbGvbhwpnaMmp02pnjYbNmzV88FfN0cbKRSjr3qEA3u0UXlrP
         VQ4kEbtDixvouK9mBA5gqWPX3AhOXPMTaXJ+k3G14tApW0tElt93URtFIoxqRzloDjmW
         pQO/8K6Jr1taRMxFYTGsq1Up2GkQs53pYEiXj4GAKr+OQz2//BK67JXGqe4LHX+0xFIj
         i672tCnJr9zEe3H+R4Rm9iKe/HpjjWYcK0i+mTmZ0UpmJC2vuvUtNo9iZa22im33rvRD
         yRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=El9vP6v9P5qhfX+EX/IA3Nr9ZJrWr13ab3q+0KHTw94=;
        b=Yp0geHBy/DXDI9GYYkqsbrpSNX1NfGD8wsc4VAWZ1nNqU8VgqJAbEhWtOAMgOCtEjg
         usBaIjMCR3BjVThXATjHnbNR+gfct/cOMxtzK8Gp8/dUvOgESn1Ml9VmJyAdycecG/+E
         uB/RnC+nPfB9SgUvdOY5FI7jJyYi0LrAYEquKhkoj2BxQWgwnvLSliOtMpfGuN/aP+1P
         hv3UJ5Vn4tZATxW9meLEGZ250t1fvwm3sPnPMgvd0cVrkU9UUUQuKF8gxHk+QvKoEDwc
         NuBvxt+PNWfjM2XnCiS9qYXVzc20b9I/iIG5j5TxqqUykRKfuPtmAI6q+kTFdzDqmiCg
         C38w==
X-Gm-Message-State: ANoB5pnZQUxgSz3/EjiYG3BHgCos3gbnBdxu9PYs9UMB/1J0nZxq6akd
        8B0DmCDTcvv2Ltt9ZH43hrM=
X-Google-Smtp-Source: AA0mqf66WLv/xQiNvEXQ+2Cvs0ooZdbDAhjW79pEqMxWecapJQ+C3hZ6MjnR7R6dkisowy0+bhoMqQ==
X-Received: by 2002:a17:907:7656:b0:7c0:e0d9:d1b7 with SMTP id kj22-20020a170907765600b007c0e0d9d1b7mr6458171ejc.0.1670624023977;
        Fri, 09 Dec 2022 14:13:43 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id kw26-20020a170907771a00b007b29d292852sm362770ejc.148.2022.12.09.14.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:13:43 -0800 (PST)
Date:   Sat, 10 Dec 2022 00:13:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 1/2] dsa: lan9303: Whitespace Only
Message-ID: <20221209221341.23mtywxgp36ol4mn@skbuf>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-2-jerry.ray@microchip.com>
 <20221208171112.eimyx4szcug5wr6u@skbuf>
 <MWHPR11MB169375D09616C6EC3119B972EF1C9@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB169375D09616C6EC3119B972EF1C9@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:25:15PM +0000, Jerry.Ray@microchip.com wrote:
> Hi Vladimir,
> 
> Thank you for your comments.  I will rename the patch to be more explicit and
> will address the tabs-spaces issue you pointed out.
> 
> I'll look for a better Linux-based text editor this weekend.  Do you have a
> recommendation?

Text editors are more of a personal choice, I'm in no position to recommend
one over another. There are quite a few which fulfill the requirements of
proper code highlighting, given the right configuration.
