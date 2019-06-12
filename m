Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C5A42BA1
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfFLQBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:01:23 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:54246 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbfFLQBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:01:22 -0400
Received: by mail-it1-f195.google.com with SMTP id m187so11642876ite.3
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=i5O+8sQiygp4pa35+sLzuYzvSyT05n5dIkz/5Sv7UtQ=;
        b=ytb6cOY+ypGyiNpv4FWZUOqd/kGLCtDOfvHJdPytP7RGfTxNq4ecFTyL6kjTxhTRaG
         DBsbdZ5YClETZxyGk0Ck6XHAnBp09VSUj7yxh0dDDk7N6YPWwHQ8OTfSK8W2WpCZTpUZ
         O/QdSUofwDtaJv3HoTw3t2vN6jI4Iale+TLe1NAaNYhV0TK1eswQWWZg+pGqh8w/OJhU
         SBuMcxeBkpux4WTxKF6ja7bauAQhlWZEHwR3k4t3twxM3UNpGTa5h4ipWHPn8M69VUPi
         BriUt7G3oB7nyplS0HEutq/eGGlUyy12S1rcCz4XgPGsLAzhveN7aZXeRHO6bFW04vVD
         lC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=i5O+8sQiygp4pa35+sLzuYzvSyT05n5dIkz/5Sv7UtQ=;
        b=R6rJcSmitX5RFYlxFeS7hUAFe948gJlwMeJPxM3F+7PjKycyk5MqyDubWE+1Y+SKob
         EnfY6zIvdBaDL9CIhXdR3kuayAdxgRO5HM4A0LYqdEY5F4313rPKI515lARE3HPXZB+y
         a8P7jS8Zib0zXOk0q/yVKhvoHPSf5ddFlG1JIpcnL04gTMQ3PhyleGIwZ0BH30EmmIF9
         nljFjDznwsOHYZHpwCIylkkVCutx9zzyAJJqgwfhPG/yvZiYteJU8hfrfPG8MdYQXsZV
         1aNK2a4GeZNHDKFuXugk5Ky8KRiTDxXV939/VR9mJ7m8jQ8qmipYnbMqVe5+I9S7lt4K
         iNLQ==
X-Gm-Message-State: APjAAAWA17aXmD653w2BUXHeAzZwXnTN1EQMNd/nE3RLHbbJM5d6s89X
        ppLKo+r6E1Qz4j4f7V6n1c1J35MrzyM=
X-Google-Smtp-Source: APXvYqy38m08C8lK7DLvfk1MKMSmr90sBYg/2MVSkr1By8oP6bbv0IW4E3vKdyc2hi6esT+XJoG7TQ==
X-Received: by 2002:a24:dd8f:: with SMTP id t137mr23072773itf.35.1560355282208;
        Wed, 12 Jun 2019 09:01:22 -0700 (PDT)
Received: from sevai ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id p3sm41653iog.70.2019.06.12.09.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:01:21 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
References: <20190612092115.30043-1-liuhangbin@gmail.com>
Date:   Wed, 12 Jun 2019 12:01:20 -0400
In-Reply-To: <20190612092115.30043-1-liuhangbin@gmail.com> (Hangbin Liu's
        message of "Wed, 12 Jun 2019 17:21:15 +0800")
Message-ID: <85imtaiyi7.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> Add a new parameter '-Numeric' to show the number of protocol, scope,
> dsfield, etc directly instead of converting it to human readable name.
> Do the same on tc and ss.
>
> This patch is based on David Ahern's previous patch.
>

[...]

It would be good idea to specify the numerical format, e.g. hex or dec,
very often hex is more conveninet representation (for example, when
skbmark is encoded of IP address or such).

Could you think of extending it '-Numeric' to have an optional argument
hex, and use decimal as default.
