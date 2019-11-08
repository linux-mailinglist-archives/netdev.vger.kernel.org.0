Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE40F3D7E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfKHBmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:42:17 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45801 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKHBmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:42:17 -0500
Received: by mail-io1-f65.google.com with SMTP id v17so3481277iol.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 17:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJ/qm2JOnzd8OdsNenDmUxwWka0qRwI2Fo+GHuvPjS4=;
        b=Q32ivsx+Yk6Jl9sizGOxP9afLDjI42WGzM9UBG2CKUzndqu034WA6ZLz2VLSptgSas
         nrXhOtitME5ZIA7CRn9iuL33GFisn8pRZk54UjmFRELq0zK6axA+n6ofHhfjBAR93qqR
         8Rb1FliHrL7I3jamX3KY0D6kjT+nC9osOqFay2t263emSEUmNIKbqpaSNoKI8wdCNktA
         hbZSIMBbCv9HU7WjXwxVJQxm4EDwNpIso62uaTAUy6u1LDJAagBKxn9TOtyZ4ZdROJNs
         SIWXP7hKZBIYqhm0wjVZaZBM/nv5x4s+9jC/eNyS1/9+Rxo4fEnF6QcfP8x9OvAD2PKY
         GAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJ/qm2JOnzd8OdsNenDmUxwWka0qRwI2Fo+GHuvPjS4=;
        b=UmAH4h5CAcohqz2tObFm/3DCu0zgHDNE2BywSwa0Z5yyffK6kYP+RCShgfDsGTaikM
         poP055AKSIG0C468O9GJ7vgOy7CtyWMyiQTmcalfkKA21YSKIhtZMJRyhOuyaXcyB+rp
         htzLmea3S49AROIpd90nBVjIWpkUOpqUFXk6KgkPJrWazMNEvFZSJerYeLTYtu5KL6yH
         y3mHjgqMGSpgxSR0n3mjjB0Kw0tGytw5Cv+PDMGDq52RhZ7653Q6xFgOJL71hp4jAjoC
         vuQwzzEWL/2S/akgQvX4QqsyoAO4KIjIhpIPSvHglB8+y2m2tJkkESI+OlkOG9dxqyyB
         4Lgg==
X-Gm-Message-State: APjAAAUgCONrfPjKFj/PowQvweXmAvMx27je8G8GlbyBvsamdbAw5xdu
        u5vtge4Fo+LOIftIB4cQZd6ehYmR
X-Google-Smtp-Source: APXvYqwTg3g/RvGNA5XqCc05UNJq0dzIT+1LkfOpbIUqqoha6OKto3L0DURoGd6J39fM64jAAR4kig==
X-Received: by 2002:a5e:a70e:: with SMTP id b14mr7532465iod.166.1573177336302;
        Thu, 07 Nov 2019 17:42:16 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:48b9:89c9:cd6f:19d4])
        by smtp.googlemail.com with ESMTPSA id a18sm359335ioo.11.2019.11.07.17.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 17:42:15 -0800 (PST)
Subject: Re: [PATCH net-next] selftests: Add source route tests to fib_tests
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
References: <20191107183232.4510-1-dsahern@kernel.org>
 <20191107.161732.1974074514689745098.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <650f515a-88f2-f9c6-3167-920dd7f12f80@gmail.com>
Date:   Thu, 7 Nov 2019 18:42:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191107.161732.1974074514689745098.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 5:17 PM, David Miller wrote:
> Trailing whitespace which I fixed up.

oops. A new setup and I forgot to setup the pre-commit hook to run
checkpatch. Will fix.
