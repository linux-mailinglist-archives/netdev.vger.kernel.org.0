Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF12139D8
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 14:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEDMlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 08:41:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41470 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfEDMlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 08:41:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id c12so11177382wrt.8
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 05:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=96A36n5S3j9B5lM3fj8KEtqLX/ej+ozPQvlOWhQuFlo=;
        b=GMOMY9YidbsITuvsYWRX1SlxKhWlqpsGIYv06nhIVD6ZJEWddLCur1VF1WiubH8vmE
         erVPPSKqTd+3PeM48FBG9DnuQzmECDBiVSUUPUxbqTVomqP9JXTk2fAOEuLZ+P1foCUD
         FxOrweCCovomsN/wtyZWIwJNQWL9/MsshYBEyKLQkDRVpHdabfzbPFzRAwD7OYQ9z8oW
         S+vjrrPY3NMb6MFbWv395yOfwqcK0e2h3S73/xprG3pT5Bk86zSXe/pI2TpxpxzpAbTV
         qCPVG1T6WAaAoQ/O5jdnJXzcDMFk3bffQCcXiwxNK+4mgjCaP5JuiJ1bvnGyfWy/97VL
         IHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=96A36n5S3j9B5lM3fj8KEtqLX/ej+ozPQvlOWhQuFlo=;
        b=lFBf8CmiMclfOv8TGfcH1/MuC8kPajcXhz7XCeqsp0CXiI7KStLAoUJn4aDtsavKFl
         eFiYSPlWdlUMaKs7m003r3Fr53BOtQ6I/bobtPd6LJvezvZnnfpP4T0Z+nq4Jq8HU48V
         5YZQs6bT3FnFLnMonEuVsuRpjGI5wcw3+qkTESr3Pce5KFojRKTqG1fPFx5gtY4qiyKt
         FNpwNuxIyEiebfZnP9f8PFHhhc9pYFISOVzdAMOYLXrH1Ea1r6XCRU/+sL+MqSoXp90t
         op/SVHeJnxk4DQ7bYyMJDbMKAVVaPybZlaXsDAxZsSFxPM/hDbugA8RjjI430JJP6f6Q
         z0gQ==
X-Gm-Message-State: APjAAAXZt6g+ZwyXzEVPOPlgELz9OO3seVa8RH+aTyj1q/MabyQDyPv5
        rrO7XnQ5dNWdv8FCmo/sa5Cm/A==
X-Google-Smtp-Source: APXvYqwRdwtyMAeCJs0O6HeRvN9r6u3XLu3nGJRgz8YR0srZw6YSUXEJU/DccZbSZ8fZg78eSqtMPw==
X-Received: by 2002:a5d:6642:: with SMTP id f2mr1456526wrw.75.1556973661749;
        Sat, 04 May 2019 05:41:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a10sm3516108wro.67.2019.05.04.05.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 05:41:01 -0700 (PDT)
Date:   Sat, 4 May 2019 14:41:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 01/13] net/sched: add sample action to the
 hardware intermediate representation
Message-ID: <20190504124100.GB9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-2-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-2-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:16PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Add sample action to the hardware intermediate representation model which
>would subsequently allow it to be used by drivers for offload.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
