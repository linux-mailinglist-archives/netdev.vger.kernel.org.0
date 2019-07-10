Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9464EC0
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGJWnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:43:21 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:45634 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGJWnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 18:43:21 -0400
Received: by mail-io1-f41.google.com with SMTP id g20so8264440ioc.12
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 15:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UT14Y03o6SXh4VNvNI9ZCs3qXqVXRXCtVwg4IxmOQzc=;
        b=ZlZyD2NwKipmUJjoZiLUFMz5Cu6icpQ9iuLJqplf/m5R/atQBc5oEgsE3ODj/EnCV3
         nGvieHhGwtkUkSZ6wHQodmfsAF28MyrPbnL4xpPsT/bJDgyI02rNbKryDgtUgiu9TNlh
         O8CHoA/FFoAfsGlmJkRKHZFqH5OBTH4j3vrrYFrYqoAWBspB4j0ar2dpCn0MNctZXkvr
         orZSdUaf5SluvaKUOTXezn4ppw1rb8G1nkHPKVHCAmyAX2MFS5HvKIdkF/7n1NUDPWqF
         i5RIYjkkTqXp8OjOWQwHR4YSww5g9W+J0X/DAm9PXEi9hQ5AjbWsus+Cizb6aF16ar7a
         tUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UT14Y03o6SXh4VNvNI9ZCs3qXqVXRXCtVwg4IxmOQzc=;
        b=LuF5Qv1vrwRg2BPF5UQ/IH5XfGY7GY5YMjJ+dEN15A0jO0nkWosKHiMfXj3tAvmA8T
         zbwN77szIHlRbTxY5cOgW2041gOEKlJwcieMbDGua0pOwlE315TXDcmknQ7DY00MH11x
         69xNIufZLzi/2eLcEzfoqkTp2PvPBlEM286eqgqT7BSLl5xdSMO65pbOBX4nfJPQb8GY
         l6rZMhyd4p1l9PSnBgMPxHuUF1HZ0SHuos07oUUO+X1Q7RHP+yGk8aDncFReEtQ3Y2Ub
         mlxxukxXLEQ2CsuXzJpaso0RwyNYqeivTA8N8qT/8SZvriFN32YjscUlz1o4tglt40WK
         bCYw==
X-Gm-Message-State: APjAAAW8H9FfE6a5U9UDEoNofpBb9CE7x3QphAvnNEG4lgYSy7f9JvJ6
        gAlcoF8lKbSjkyXXcXWIVUL41iOV
X-Google-Smtp-Source: APXvYqyLS1HNsJUxIcq5pSIfIxx1NWbmauHgYtpzq/irp4JpIU9EWbvdzPri0k0ImMDhY5ocqGdOPA==
X-Received: by 2002:a5e:c70c:: with SMTP id f12mr603521iop.293.1562798599952;
        Wed, 10 Jul 2019 15:43:19 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:3913:d4da:8ed6:bdf3? ([2601:282:800:fd80:3913:d4da:8ed6:bdf3])
        by smtp.googlemail.com with ESMTPSA id j25sm5068793ioj.67.2019.07.10.15.43.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 15:43:19 -0700 (PDT)
Subject: Re: Fw: [Bug 204099] New: systemd-networkd fails on 5.2 - same
 version works on 5.1.16
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20190709074344.76049d02@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37ee2993-f81b-6265-87b0-1179162f1a2d@gmail.com>
Date:   Wed, 10 Jul 2019 16:43:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190709074344.76049d02@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19 8:43 AM, Stephen Hemminger wrote:
> Looks like the stricter netlink validation broke userspace.
> This is bad.

I believe other reports have traced this to

commit 7dc2bccab0ee37ac28096b8fcdc390a679a15841
Author: Maxim Mikityanskiy <maximmi@mellanox.com>
Date:   Tue May 21 06:40:04 2019 +0000

    Validate required parameters in inet6_validate_link_af
