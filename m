Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B04235A7C
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHBUYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgHBUYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:24:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873F2C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:24:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o5so769455pgb.2
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fgzhto5A0iyEyMlsQOv+fJtAR0VWY9wVoUgJSGksBTY=;
        b=JEUo0+NjF1u7KdQWAPXWm1Sjd/Ki9vF+W+WZfXFFwr/HE5MhAIJHSNaNgdrms6jht9
         eO3XTO0aWL4tlIUZKNHIsFL/4z6XwDd/FLwQfzdhKIUd4d2NLhD9fAZdT4N6ofUkvJH7
         ls2qZ62KFkZx8j09ucyUeRg1JNNF88bMUwEsJfjU2cFD2QBi4HHjaxbbVdsuxMelKToQ
         N01sIA+F1uJnDZy05YdBDZECpK/4CjE+VmdXZnAoPMqV57/EFqBNXNgrUseq5gbsnh2f
         EkKJs45aN2IhmUrITuECLAxbQNyo6YnxmjNAO0PzNalPeJum8EWTDbDVYZBaWP1ItrBo
         S0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fgzhto5A0iyEyMlsQOv+fJtAR0VWY9wVoUgJSGksBTY=;
        b=VnIxCZiqvfIgeObgFcihCQNebPJfXOdpEQmDxpdM3epUW+bBRqYJ/2kSei8DsUTggn
         HqyHaAwyN6P58LnlgZEoNjv5EUjTvRTrGPeOiL+tVUwKypJEk6eEG/TVK1eVYXQALaF5
         5gOKkMzhErbyxaGPi3PzHSEaitNOplJ+2NL8iPSyhx09fqgQ/st4cmiRqHtTnLSI+QFK
         ROIpQ88a/GihXqO4YMC+h4/tZXL9sBfK4RpJ7Fbpol9NOcZavIs8BKvoXYk8XH420tU1
         4rsd6008aj80gJ7x+WVZ2bhXt/4+p8avU6N5qxt1b16enZ8fdg/tMjqJIMExANLqXije
         66gg==
X-Gm-Message-State: AOAM533QeTC7WP+w0p503ouYk6QCWBoP3VFRnPOgv5Ws5XLHowcMSf4l
        4Bj5GMg+hHQ0hVeps+6M5fU=
X-Google-Smtp-Source: ABdhPJxK4cT9GGatS13twMzTef4nFe/dZEzGF5RLM4RRHuy5D23gn5/Tzv5TmPddjfdcDdupJpfaOQ==
X-Received: by 2002:a62:15d3:: with SMTP id 202mr12883752pfv.326.1596399878080;
        Sun, 02 Aug 2020 13:24:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g9sm776216pfr.172.2020.08.02.13.24.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:24:37 -0700 (PDT)
Subject: Re: [PATCH v3 9/9] ptp: Remove unused macro
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-10-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8c65bd05-6847-6bb7-7630-c195874a16de@gmail.com>
Date:   Sun, 2 Aug 2020 13:24:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-10-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> The offset for the control field is not needed anymore. Remove it.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
