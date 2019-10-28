Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E05E73FD
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 15:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390335AbfJ1OuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 10:50:01 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:36417 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfJ1OuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 10:50:01 -0400
Received: by mail-io1-f54.google.com with SMTP id c16so11011515ioc.3
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 07:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o9XD6Sny18xO9tLJN+WtcRFMjlTmJsvTdEL+lFzcstg=;
        b=tqBdhP2acvZB3jeH49XEFczjFsG8QCSM0Cj0LAZymFb30DylQu7t0Aj7JhaIXwfnQS
         WT7+XMthYPEPqOxPBLLVGRajUJetGaNcWTDi2M7Cco5rz2/79Vywd4VwB5+eqZfKw2lm
         glRXorwhBEaSGW0hfsEOHWd0j80xSHwIxhM9z+Wy7uAigJywzj+QgTnuzltLg13qUaSp
         RFdA4Qz77P41I2WvYsS5OSK0XbBEuqv8WLSqGJXotrmfTm5s2hPlLQqwA6h0dKq0TDsi
         9X/qlWmY397/wSis3LdWsYzRBxZKpkXVexzlytoVicwVI3XZUVrpMxXP7hVPrziqxXpn
         L+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o9XD6Sny18xO9tLJN+WtcRFMjlTmJsvTdEL+lFzcstg=;
        b=ad+nlT1UVfhyn1C+OduqgyYLUlla/3W4H7RB0Iep0zDh+TfFtiuTTBYWKFQCbAbCnH
         7Nabu3ZKergf0W+DL/PfOj1T50APkh3IKcsMVmzE8G9gqHxPM7H/+hkgg1o3gAisWx9U
         oIIPJHHrs5bL6qxaFRXFUkVLBHi66N7ltlrpc0KP8e3mI/s+Y1tPC+5pIpfqPPJ/3Xil
         mIY/LRGWAG8c+TdxnGGuUCi6W7CYwsueRC7QxsijxFtsAo1Y45CNPEWbCHPVBEMS9JF8
         XUkpyuGlXP+Mfy4cySVZH/DJTj2a7/shZo/jM/0ObIWFr/hzYGCOHTS9erQNWcozuzPQ
         fHtQ==
X-Gm-Message-State: APjAAAXUzBsD64NPSkAYDT4t3ENVJ2juSrt0MMPPSRDt+hum1WlrDNCD
        jB3SiLRZnmw/dkBaO/6bZ2w=
X-Google-Smtp-Source: APXvYqytxlzwQxu0mzHx+nPgpEzDAgShGs+4wd/nP/GB8lOBAqpqDVDkwWXJvFyfMc/Px0+Y5fQ0/Q==
X-Received: by 2002:a02:c78d:: with SMTP id n13mr16986222jao.11.1572274200557;
        Mon, 28 Oct 2019 07:50:00 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:284:8202:10b0:9e2:b1b6:1e7e:b71e])
        by smtp.googlemail.com with ESMTPSA id q80sm1605204ilk.43.2019.10.28.07.49.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 07:49:59 -0700 (PDT)
Subject: Re: [patch iproute2-next v5 0/3] ip: add support for alternative
 names
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
References: <20191024102052.4118-1-jiri@resnulli.us>
 <c8201b72-90c4-d8e6-65b9-b7f7ed55f0f5@gmail.com>
 <20191028073800.GC2193@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <057f3a0d-b4ae-8810-28dc-a92866f976ae@gmail.com>
Date:   Mon, 28 Oct 2019 08:49:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028073800.GC2193@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/19 1:38 AM, Jiri Pirko wrote:
> Did you by any chance forget to apply the last patch?

apparently so. With the 3rd patch it worked fine.

Applied all 3 to iproute2-next.
