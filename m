Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01511092C5
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbfKYR0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:26:34 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35418 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfKYR0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:26:34 -0500
Received: by mail-ot1-f65.google.com with SMTP id 23so11552638otf.2;
        Mon, 25 Nov 2019 09:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FNPvUWiTudncyl3KlhHhnfA/TfIBtBh/b2tPc9Hn/P0=;
        b=Yio42PV7diBoMffXmGQ/mrG7l+5yxECdy6vmqgPadep4Ae/j4fDg0J//zWFt0WSMs9
         AqfiRzHruO0XR27BmUuFQLS/J1qaj49Il661qAwifv5UtM6rHGmYIg3n+GmoS7a4g9Rh
         gBqOhIjRnEq7ki57nreHJuhn3TUwDqkN26oQ/LqqKveQ3+ip75EQWxUGlve5mgIAm0du
         Wq0gm/q7CiBrAVxXCWiPsGPf1LsIA5z3E9yg3KTvmtd4kU9pMIXPnL9yQy+MAV+MR8Bv
         ZFtAYdWQ5AXpUpi4V9YcNijBH8uUn+IYyhmt5riyGtnxHjpksT0bl3VNlefXIYt1A5bp
         /Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FNPvUWiTudncyl3KlhHhnfA/TfIBtBh/b2tPc9Hn/P0=;
        b=mlpYQ00aszkuvwsxZxUEHRsAqRRV7sjIGslP7ZpUbGmC9Wd2ysVviMZxQ8CXxu0cZZ
         nxa996TDLdGau5XwQKANYTEIm749iIkJtvFwKsw3a55JgK5Kfk7ekbJlNaU/fdHEo8wq
         F5r70GcwpJ5Zmf9jEyAckTbUOZt+iypz0JzalCpWWtZrvgRuLyk0oaQmailFZp2G3cE2
         RMFIIYO0HdMSJFoaV34xCbq6K/7RXht/LL8TuxxN7mW5JPBED1I85z21jVOq77FGZK8d
         jbHjFOCH0pRySJWyE7QVBIM48i8G0fsAo34W+XnyWB1OTcKCKnYFYrTPR6Sd2Rd7HFxs
         ebwA==
X-Gm-Message-State: APjAAAWPakPDLKY2jjV5s3YM19MtQg0H4w++eoUhMmq/LW370N48ZYcb
        Y35IDydUMJVN1TQwBQbGCoJCxx5h
X-Google-Smtp-Source: APXvYqzaIGiKjJHMNBMYZekDl882UWn5zUMKBtDtoVpJQ3ktpr5nD+YwavfA2Hl51LllxUgn9RHsYw==
X-Received: by 2002:a9d:3982:: with SMTP id y2mr21397853otb.191.1574702793182;
        Mon, 25 Nov 2019 09:26:33 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d21sm2589951otp.66.2019.11.25.09.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 09:26:32 -0800 (PST)
Subject: Re: [PATCH 1/3] drivers: net: b43legacy: Fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        luciano.coelho@intel.com, shahar.s.matityahu@intel.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        sara.sharon@intel.com, yhchuang@realtek.com, yuehaibing@huawei.com,
        pkshih@realtek.com, arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191125150215.29263-1-tranmanphong@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <07e73c3b-b1fa-c389-c1c0-80b73e4c1774@lwfinger.net>
Date:   Mon, 25 Nov 2019 11:26:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191125150215.29263-1-tranmanphong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 9:02 AM, Phong Tran wrote:
> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---

This patch was submitted yesterday as "[PATCH 3/5] drivers: net: b43legacy: Fix 
-Wcast-function-type". Why was it submitted twice?

Larry
