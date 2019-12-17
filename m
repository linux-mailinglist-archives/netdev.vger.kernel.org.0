Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5CC122FB9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfLQPIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:08:34 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39945 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfLQPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:08:34 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so2244003iop.7
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 07:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S4GfhuHqSP1p4HsrAHQ8o/I3flV9IWgew5vVTB94RDI=;
        b=c+aoxhCnkdWqrtCuQlNF5MeTYW/roWAfEWI88rKdf98A2NdQ5CMHVJZEa1yUgsVNXS
         pH24RS/ip28FrlL/Z21Dgu2yKaF0hEKiWjI2TAE/KGeAArioxLwTUtHGSQSPS7K6Cx4V
         1Bk7/kf9vKz2Sia3qtZ0X9DT54WJXOVjuKk60dHAzc+5XZvqHwq48Uecw4P2ti3Gpkkw
         /04NGjpCp6fJGodQ63j0VIdjFI+wpvYsKLM1uD8xl5X6BYvGiBQ7gP5LKtgpya6uf3zn
         02wX2LllS7SQs31VpYC3u4lOUFQgHVk598vwBiPA0rvAotPw6s/TpQSLHquNKkx0orh7
         y4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S4GfhuHqSP1p4HsrAHQ8o/I3flV9IWgew5vVTB94RDI=;
        b=c3g4d3VjBOA8US2Q8ygK7SRAszAkP3l2jX/zyxZb68Z+SKT5T8yCW2NSlneLvrdaAD
         wyaoYWSY9ExG2UHtOoKaR4sQoLHSKbW0vXIIGDi1Q+Trw+eOZIRZz35dLRlaWPf8MXPT
         pFkiOj2Ct7xpv6ksk/AuIBW9QoNy1TUdK1tjiW6p6TDt1+7zdTDeIplQ41fKQcQ6pIvq
         5CjhB+YoA/TCv0BAqUBHI2hVSUZ5QpaUZRqg68iKFm3VJh94JG/qMk/93YUH+Y74C75b
         pHOn8/CCV2sLM9mC5egdwmXkbLOGgfjbFl+eoVYePwW8Ke9udA4lqLrMZF4cnPlbzdWF
         u3ow==
X-Gm-Message-State: APjAAAWgCotKKEd16Z7hIBQrjyk13XFEP9CVBQ1I62luq5xM067M2lfB
        13BmfbAktWOOnBuhgk+xTg0=
X-Google-Smtp-Source: APXvYqyr6kf8xogqHYUBW5YOhklx2KXgApitUtsFqcAYwE19Vq1BS0fy0ol1ueriE20U1a0QUDgf8g==
X-Received: by 2002:a02:cd12:: with SMTP id g18mr17499743jaq.76.1576595313846;
        Tue, 17 Dec 2019 07:08:33 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:b136:c627:c416:750? ([2601:284:8202:10b0:b136:c627:c416:750])
        by smtp.googlemail.com with ESMTPSA id q6sm413475ioj.49.2019.12.17.07.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 07:08:33 -0800 (PST)
Subject: Re: [PATCH iproute2 0/3] Devlink health reporter's issues
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@mellanox.com>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        jiri@mellanox.com
References: <20191211154536.5701-1-tariqt@mellanox.com>
 <20191216205351.1afb8c75@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a75df49-e3c9-7b67-a0da-94dda9b06465@gmail.com>
Date:   Tue, 17 Dec 2019 08:08:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191216205351.1afb8c75@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 9:53 PM, Stephen Hemminger wrote:
> Applied, devlink really needs to get converted to same json
> library as rest of iproute2.

We have been saying that for too many releases. rdma has fixed its json
support; devlink needs to the same.

Maybe it is time to stop taking patches.
