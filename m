Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4A251A5A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbfFXSSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:18:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35309 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfFXSSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 14:18:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so314919wml.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 11:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jaHGo31EkX+LkNc/w2OWRKDHhwqd2JrPx8kadgAguhk=;
        b=AX84C2PyspC5HszFCtx9q+e6vAuDhq7TRD07l3UuigMQ3cUqDLvX1CGv0B4r0oowTX
         ediD5/cC+0j5rAWTTC+kqj1hKxxgsddruFk9PXhdKz+cNRvSf/EGgKPopYWKTo+SGvjP
         9uISyGRHpdZxvuF4Cq4d4YWvszwTNlpHdEel58zWbYvzDvRF3/nB9UqEukBl7gwx9DZR
         uWWoderexmfid4QUMmktkd5hoEND6YL0/DAgmlNYBpdMHm+DN/jX3/8LezWqd0MZPybh
         5dq879DmtDENfB0JcQVlt9Qqhg1rl3AlhGxHJONlvp8IWdK6wNAnJ3aOJOXsPGfmSTGl
         JUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jaHGo31EkX+LkNc/w2OWRKDHhwqd2JrPx8kadgAguhk=;
        b=KIqDEB4QXtMQjEJ2DlCkOhjxE4jnPOjUzgbk4gPCTBfXQN63CmaXuAHxIdoCf/6HoG
         ZYUCefEhWtoS83Ry8eWjNZYNrFoDK4GYj2cGtY7jP/D6AgjB6ISdDLVmo6aUSp0c6A4w
         X5lYCocu00Hp2DtRMiIZjNmvXdTqB7GeTaOyTRpRZQ1qBRohJ28rAkbc16WBk7UVKtH7
         k0fG/e9IWpPej/M0OHe3LAyjem97yw1vbZBu7LI2bMFnJWb+NpSZtqsNsTD/uDv3Vb+G
         riZ0qVJ+nhnp4nxyunVeCh0TQ6SW06m+ok/4h8Bx0I7L+eLOT72uOF6fYiJfkenMrP6F
         Kmxw==
X-Gm-Message-State: APjAAAU6dpq/rE2Bk7Akw4Zx52sFUwO0AFa/dRS3ZtXTTJDGFtgakUZ7
        oSHFq/K4eLECNMIZHsmqcy7Hzw==
X-Google-Smtp-Source: APXvYqy44QJ0j3B+WNMeiCd2joiGjPHSQEYixlxmRLzGxrDhrlTkjcaUMXlGUAszRd2xOBBTVa2N7w==
X-Received: by 2002:a1c:b457:: with SMTP id d84mr18124060wmf.153.1561400319010;
        Mon, 24 Jun 2019 11:18:39 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:b5f5:169c:46c4:90ef? ([2a01:e35:8b63:dc30:b5f5:169c:46c4:90ef])
        by smtp.gmail.com with ESMTPSA id q20sm26601798wra.36.2019.06.24.11.18.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 11:18:38 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
To:     Nick Desaulniers <ndesaulniers@google.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kbuild test robot <lkp@intel.com>
References: <CAKwvOdk9yxnO_2yDwuG8ECw2o8kP=w8pvdbCqDuwO4_03rj5gw@mail.gmail.com>
 <20190624.100609.1416082266723674267.davem@davemloft.net>
 <CAKwvOdmd2AooQrpPhBVhcRHGNsMoGFiXSyBA4_aBf7=oVeOx1g@mail.gmail.com>
 <20190624.102212.4398258272798722.davem@davemloft.net>
 <CAKwvOdkqE_RVosXAe9ULePR8A37CHh6+JtDMaRAghUA41Y_+yg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <3d7c16c4-9c3e-d18c-aad4-6583216ea457@6wind.com>
Date:   Mon, 24 Jun 2019 20:18:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkqE_RVosXAe9ULePR8A37CHh6+JtDMaRAghUA41Y_+yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 24/06/2019 à 19:37, Nick Desaulniers a écrit :
[snip]
> 
> The author stated that this patch was no functional change.  Nicolas,
> it can be helpful to include compiler warnings in the commit message
> when sending warning fixes, but it's not a big deal.  Thanks for
> sending the patches.
> 
Yep, but I was not aware of this compilation warning. As explained in the commit
log, the goal of this patch was to prepare the next one.


Regards,
Nicolas
