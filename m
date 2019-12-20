Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16DF127AE3
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfLTMTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:19:37 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:35025 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfLTMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:19:36 -0500
Received: by mail-io1-f48.google.com with SMTP id v18so9202989iol.2
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rLYZ1ACVweyb8lqqBeanb8Ib1QlzxP8QfZsN+9f72no=;
        b=Tu01xGKpzupo/XzqetKRuuWQz3RbPzeEJtpks7c9JMnVxiyeHXoGeb8y4ybrK/k0L3
         kwKTH0rtjYwWf/OsV0+SjT/nHxF7KJCIqtVRFCnZ2MNVvM1gdq2Uyb4ZfxBg6a3mJRQ/
         F66HJ0p6cGbBMlbhIQDaTi3MY47nshHvtC7RVqXgxbb319FecramyuGIacL57APejwZQ
         cPItqcl5PxQb8NJ53Z+n8EqoLb2C9E6SuLfkhVRUtG+DkxTddwChrh3VV4UUISag01gF
         lUjzO7z12DFrqcP6WiZmB9lbf6bNAMZ8PDWbf8eJcLiRdUFxcI+YHiy8ail9rINQl7P7
         iE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rLYZ1ACVweyb8lqqBeanb8Ib1QlzxP8QfZsN+9f72no=;
        b=Q+kDs2b3l7NZWaqQc+OOJU5d1OA9OSX8QAR2ZrtksVqYdWxBStBoJlKy5k5HstXvFk
         7liIc6l0vO6GP4EZPRfcpak9IoRwLUsHSyhEySzfwDG0agVtzWryisSGSvKS3/Aj3l+J
         c096hbcRdKPVuWpthDmuQtHT45JbNWVX2qnRX4IO25gyAL/Furs0BcIQBXZJH6JwHUC0
         o3J5ToyArT2ZPVoLNE/igI0aW7Lo7yZ0bYCQePIMZAbuFvZe+Uy7cKtVIOoUFY66Czw/
         Ro6oYjuDjsRlXL8HLW22TcLpTsRkLGUaI30y84hk3KWRUKxDey/8GjcSNp7c/6FD+c1M
         Wavg==
X-Gm-Message-State: APjAAAU8H7xVaabffNlFHQyx7oL8CJM2rVjIRk9AQEMUg7KZJFSlMqP2
        kxhICrfmuNTYxImP0rpVzkmXUfGfKmU=
X-Google-Smtp-Source: APXvYqywele2eSILKiOtP/lKnLDZieUPdFEOh8AWu6RmykMq2gz3m/7NdbOsyo8fe9y0eZqtecjR4Q==
X-Received: by 2002:a5d:935a:: with SMTP id i26mr9246555ioo.127.1576844376115;
        Fri, 20 Dec 2019 04:19:36 -0800 (PST)
Received: from [192.168.0.125] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id g23sm1661291ila.15.2019.12.20.04.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 04:19:35 -0800 (PST)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: issues with the list?
Message-ID: <f31715cd-ae38-b358-a507-22eeb78717a6@mojatatu.com>
Date:   Fri, 20 Dec 2019 07:19:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I just noticed i am not receiving netdev mail for at least a day.
Last email exchanges are related to Davide's patches. Is
anyone else experiencing the same issue? The effect is
like i have been unsubscribed.

cheers,
jamal
