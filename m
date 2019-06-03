Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58F033A4A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFCVwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:52:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41288 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCVwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:52:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id s57so4245452qte.8
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 14:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+VDRigI9bAvCIF7F6f/5OkoxLCCdCDUcvZ9OdP0dzjQ=;
        b=00TjDU11UTI9nRK+clcx5vKmdBh/0fxfZgmdQazK4lheM9ZFNWzd/UN1A/ptt7r5+P
         O6XZT38Lvk29MJ1AdW3bBj87vuL1MUYZpndn7QmJK+YFF3lhj/5DKWVWo4wsExM3YYAr
         FjzteRr01DEaBo4sfoef8ajb9tZB9jA7BSMikvZvKI+wnaHtqUVXB9/rhAu1EvwkPRKe
         BX+c7sOjuFuoQkbdwRw73uY0TCxbn76KGqOvZIzV5CFC3KRw4UI48MTMtxO4/nmsZfaE
         ISBBFU7uMyXP9BgvDxbp9QocA4AyvK3ZP2EQhErr9V6Nd9VrEEowwymNzJOuajmUbuzy
         GwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+VDRigI9bAvCIF7F6f/5OkoxLCCdCDUcvZ9OdP0dzjQ=;
        b=lYaoDs2H0C67d4rHwC+uMOUaTXK18fjm5FOA0Vdhheajjtm5QM7UYIhongoboMrLiP
         Uw4n1kxfugyw+LQ+hF81PwYZXE+6J0GEM5HjwwgS0E3CKQmVHp/IHjxa7oJbVFvbsNkG
         yd59rMepFRsw+gRnrlz0z0CzdW3xDu/xw9tXGYmcP2ZrTzFv7JxiMaw7kdXSHPL1NhS+
         eT4Xp4Advs78IQcVt888dIhHZiniA9jyIzW3z+EjHe458aQCgEDaG0jVlkbaow8DhYHU
         HDHLJfqrMUPrWGYweryvu0EIgOm+nqKNVSzZD1diYPkLItdz4Cw2NoeoxFgSBHoTYZyM
         WDNA==
X-Gm-Message-State: APjAAAXvzIxu0p2zj2xqyLl3Wc9u7Hb/58caXpDFW6MDRylTjW9ehfWz
        5GHtBxVZclErniMsy0XaDHvbpdnN+3o=
X-Google-Smtp-Source: APXvYqwBW7bVmHwPAPft2oNhaVDyumYD0RH4pTZFRIJlzwttjpb+F/MqyDBSIjHqLcXKJPsDImLY2Q==
X-Received: by 2002:ac8:2454:: with SMTP id d20mr24986641qtd.266.1559597531207;
        Mon, 03 Jun 2019 14:32:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p40sm11487862qte.93.2019.06.03.14.32.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 03 Jun 2019 14:32:11 -0700 (PDT)
Date:   Mon, 3 Jun 2019 14:32:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190603143205.1d95818e@cakuba.netronome.com>
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 17:43:18 +0300, sameehj@amazon.com wrote:
> * net: ena: ethtool: add extra properties retrieval via get_priv_flags (2/11):
>  * replaced snprintf with strlcpy
>  * dropped confusing error message
>  * added more details to  the commit message

I asked you to clearly state that you are using the blindly passing
this info from the FW to user space.  Stating that you "retrieve" it
is misleading.

IMHO it's a dangerous precedent, you're extending kernel's uAPI down to
the proprietary FW of the device.  Now we have no idea what the flags
are, so we can't refactor and create common APIs among drivers, or even
use the same names.  We have no idea what you're exposing.
