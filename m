Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAC3ECCF9
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 03:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfKBC7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 22:59:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42271 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfKBC7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 22:59:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id s5so3957pfh.9;
        Fri, 01 Nov 2019 19:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Q47zQREG+oESU8wjXeLd7PXi0SzgYhGGKEYowlxWhPE=;
        b=sN9/IL9sr13RJ6HGN3lSVp/q/nK4v0bRccmOBiY92WUjxX216DueFj230qt2tdFL+y
         l0jpZt6HjZZ1/mbPXyvFos8MZAYi29MZW5gMmLm1JC5XtpV1ZLwE2Jtz1KZvb0Hk3OuO
         JCBXzgIXQv5knGuIxdedD8nLB/w5S3KwQ5e6lIn+yv1wbeDk+cB6d3o8NGPXtLL01zQY
         ugBinwyNKBdDTpSw8ZMMZNCARIwgm+sm3fydSoFo3TBs99jCRYgF+rj8zlwv0S+zBbz8
         0TDJOVLiZnWV18X2/PxCjr/1afJCjrwg52GnsvJVvUXypwNMSruTnTsvGkEdafmPCB0e
         bBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q47zQREG+oESU8wjXeLd7PXi0SzgYhGGKEYowlxWhPE=;
        b=ODU9DFG00W3kp4afBNx2aLiRFX1vooGOoyXY7hGDe88kyUYWvXfvNc0+T2n1lMqiTB
         0jzP5lCMMp6/zDJ32UwhNq1c5J4hSal5hLkCMgb+glL+sQ3mbSRkCGRwJDYYdlyAZTG9
         zKinlNbWcJaFgga0QT4f47+CyA7Q4naajDVwEs0S7RJz7++Y46FWoiP9BwrXSA+Z5Na5
         dWIb4kD4/hfVzg7sE/UciffS0w3PoguZQC6bjHtIiv1fzIaCkayyCW+tgDXnsLTCXBkx
         Pjh0ACb5UdlbYUCcYvTNkFS9xJUJOT8fX1KMhY//klnzJfNkhBImambGgYCUYRGeVFWm
         KhWQ==
X-Gm-Message-State: APjAAAUmD9svbdS78ICYI75Zg9wVFRB7kUFfR3ZP/qBmXY7v8G2NsC/Q
        XXt7VWpzrDvBpmSw1J3vJzdUToiA
X-Google-Smtp-Source: APXvYqw3oQl92AlfZHpMHTHONZP/YcH1Lukwfd16CokLcAixyQ3erxyt42zzbJVoOpqHhEupgIxZsA==
X-Received: by 2002:a17:90a:bcf:: with SMTP id x15mr3957701pjd.0.1572663543926;
        Fri, 01 Nov 2019 19:59:03 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 6sm8672246pfy.43.2019.11.01.19.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 19:59:03 -0700 (PDT)
Subject: Re: [PATCH 2/5] dt-bindings: net: phy: Add support for AT803X
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
References: <20191102011351.6467-1-michael@walle.cc>
 <20191102011351.6467-3-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <50677172-0124-94cc-458c-ad4d394477f5@gmail.com>
Date:   Fri, 1 Nov 2019 19:59:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191102011351.6467-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2019 6:13 PM, Michael Walle wrote:
> Document the Atheros AR803x PHY bindings.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Nice, especially the way you have solved the regulator, this looks good
to me.
-- 
Florian
