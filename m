Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4A946D5A
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfFOBFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:05:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40340 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOBFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 21:05:19 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so2448270pgm.7
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 18:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TfquNdGzGkGuRJMLX5kp5Cck4XJr4WRj6dEBjZPKpzw=;
        b=p4jccetN1Szi4P6gwGSI0CriLg7MWQ+o7aWUI84tyvNXmeb+DDXzz4nVVQazYReV8g
         /nZgPeMBfilAz8XUtIBp13CA3E9blf0dVqS87S5hcOo+/mDfVgDVrM9PGz04xk4ag1uu
         ANv9WRZHSZ0LdSSbUUKxYFurwq5OOvwGst09E+80w4DIdFKaXwmOOfjTgjXnKVFU+/Gv
         AheKn2PzwYuLIVTCfeg2kbmhbuOkP5Gqli5qIVhWuu3+ZGRzJnBe1ezgQIxOOM/ZRonH
         1kRbEGZ+e9dG2CxVchaJ8crd+bex/Na+fjREPIaTIVTaC0q0QwE7bPsDRVuC++fgjTf1
         YmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TfquNdGzGkGuRJMLX5kp5Cck4XJr4WRj6dEBjZPKpzw=;
        b=dbvIwRh6irad/ZxTvHH9HLf1NtIetF4cy4/1FnHcwlDHLMirZwnFOF1xNqi0eyuYVH
         nYlNg8tP9Rd016hY08XbXJkM3cxxKemKPHkQ8laduAwTDnSZ4xXUl8xQ4W7034YhK93i
         o/rf1yItf3d+4WbrWCJ1mI/v/7WpzZsPaG/v4sqQx3prbOTwmBPtSbWiiI8pTND3mXcg
         SUJ352eJjfP54ud5KquDiMYsldu/o83QsuKmOUcuFooB70QjB+rGiBrF+ek0VvJnb3Ri
         gS3C8kRD0x2IMEf79/t3dtwZUzTPiSQu8r8Lrwj6NmFFiBTiDAEbcycGh50xdH0mzNfK
         MOiQ==
X-Gm-Message-State: APjAAAXkVlsXzTLVw0W9MYPx4l+/R4hsdt7V0Guz4MwTu8OfgDzOV7cv
        FI+yTHloLLUZWs2WyTbEDsM=
X-Google-Smtp-Source: APXvYqyxqzdQ9svMPeVfkzHWzbfrLlSgTO8a4U63NtAarZNvg3qbPebHTsuyBnw7XwaWEZ47DUcuhg==
X-Received: by 2002:a17:90a:d983:: with SMTP id d3mr13639534pjv.88.1560560718737;
        Fri, 14 Jun 2019 18:05:18 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t25sm3730407pgv.30.2019.06.14.18.05.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 18:05:17 -0700 (PDT)
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
References: <20190612092115.30043-1-liuhangbin@gmail.com>
 <85imtaiyi7.fsf@mojatatu.com>
 <c8bb54a4-604e-3082-c0bb-70c2ac1548b2@gmail.com>
 <85muikuh42.fsf@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9be6343e-905a-6295-4d22-795fbaf42498@gmail.com>
Date:   Fri, 14 Jun 2019 19:05:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <85muikuh42.fsf@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 1:00 PM, Roman Mashak wrote:
> On the 2nd thought: there already exists argument "-raw" for tc which
> currently instructs printing handles in hex representation. Why not to
> adopt this for ip and ss as well rather then adding new key?

show_raw seems to mean dump extra data as opposed to "don't convert
numbers to names" which the Numeric option does.
