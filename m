Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA5464DE4
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGJVB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:01:28 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35463 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJVB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:01:28 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so7865510ioo.2
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 14:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pbTdvtuD6dQM+qFDbkE7X/xi8+qtloqTvm+mpzc75xw=;
        b=e8tQHz3iiSbKMoPwwXd8RYjyr0if8LlD3akBpkGkWEgjolQ7tVNKEDbtrXe8aArRLX
         ZoELrMiqhvi+X5zIsg2JxSwjusWBuG87voYlluglu11Ad8ruSwVAJ/RkhQN/dZufGp9a
         smeI+M/L3ku80K+zFmcFd+ok+f7purs85s3DLtwkFn/K0PRuEisVowUCwwWykWpFkOrk
         hg52vFV6YGM4mT1ilgCf/ZX8rg3w9gqDjhyWlE5wsZ8DfoH1XM+q+FtQOCMHaiwQLwin
         VoOzW2JA7kgwkO9PyfGVv31yK5exc0ISWQPAOhw3CA8GFWo2tx4CQRclE+hE/4imViNo
         Ez3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pbTdvtuD6dQM+qFDbkE7X/xi8+qtloqTvm+mpzc75xw=;
        b=frdjv+4gVo12cPrJCpnULuzm6c2/uV/5YGKxYbIzLM91gqqz3UIh8gxVSW+uWSP8BG
         qHBrKBmZXg1gIYkDhCBwgsa2FPkBzQqbPE/w0u3bA3xRWQvhqgFc3h2A5n0G2aiV0rjM
         s+Jn1o9Y8I+Kt04/e58dYLCCzI5xRgKObdWDstYIUPA7qKGVWmPkRzpGsftBenrBESgi
         HfLrayhSNlmgboye4qPpcqQL0WeT7U2DXjDMaux/qtUmG0a8UbDsAEXjvnw+UPGBMqC+
         C83FtRmlYnZ3DonUzouVW5yiT6dqfH9Q5eUkII21HUF1bI7PkCI1gjj2u6vPqdbyZevQ
         31GQ==
X-Gm-Message-State: APjAAAVBv66huPpEWHRbHUywuK7T/mOaanFXQ87gl8x3vv24znh0IwBv
        zISkwF/kfNktMMUsJlhoegc=
X-Google-Smtp-Source: APXvYqzMRgzeVWS7W3+TE3bb+Fwfaop1L8S2Wytbbi12IzbfdgFLyvnspSVBLXAQ0HaN1kojbXjFCw==
X-Received: by 2002:a02:ccdc:: with SMTP id k28mr75839jaq.41.1562792487613;
        Wed, 10 Jul 2019 14:01:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:3913:d4da:8ed6:bdf3? ([2601:282:800:fd80:3913:d4da:8ed6:bdf3])
        by smtp.googlemail.com with ESMTPSA id n22sm5417907iob.37.2019.07.10.14.01.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 14:01:26 -0700 (PDT)
Subject: Re: [PATCH net-next iproute2 v2 2/2] devlink: Introduce PCI PF and VF
 port flavour and attribute
To:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com
References: <20190701183017.25407-1-parav@mellanox.com>
 <20190710123952.6877-1-parav@mellanox.com>
 <20190710123952.6877-2-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0536bc24-8818-0bfb-095d-862112cf85c9@gmail.com>
Date:   Wed, 10 Jul 2019 15:01:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190710123952.6877-2-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/19 6:39 AM, Parav Pandit wrote:
> Introduce PCI PF and VF port flavour and port attributes such as PF
> number and VF number.
> 
> $ devlink port show
> pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
> pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
> pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
> Changelog:
> v1->v2:
>  - Instead of if-else using switch-case.
>  - Split patch to two patches to have kernel header update in dedicated
>    patch.
> ---
>  devlink/devlink.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 

applied to iproute2-next. Thanks
