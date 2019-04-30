Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71983EE15
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbfD3Ayq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:54:46 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41545 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbfD3Ayp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:54:45 -0400
Received: by mail-yw1-f65.google.com with SMTP id s66so4686955ywg.8
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 17:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yVEA7mROzxmbSToIYQpcQgqWM+Kri1sLmayYI6ibLnE=;
        b=slYC23ZSZKOJmcCMW7zFSrCn5R8ZuzQJAqTt+WIEK9Bp4HzaGGYqEWeNW+YFi3POYM
         UZJD2YSBTghQK/ODXNuK0+fVIO8fIKP1PWQYbBkSL84SxKmdXZ8dYTdv4FW7NGp0BTtf
         QV9K6zl/7dLeicSn1ZuESVydGFpNlfUjynBDMvmxa1BiVVYYpFi+5TnJwLKn4ezj4wuS
         5eC3RCbL+QFMmQ6+v/xUg5na+4PFcVijX3mXUfeuASJczg3KamhSyxYpfxi3XpuRZTFd
         033rGgNrai55x/7fpbzp/0Bbl7LXZfDUfJnHeFODk3S1XbQOcehZeHKBNLHN26kcDa2p
         dyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yVEA7mROzxmbSToIYQpcQgqWM+Kri1sLmayYI6ibLnE=;
        b=Jaspty2+n6vJI632jcgcyJONF71emZOM9tXFjO9KtquPb9QHRI8gFQ24hDS1GaeBNs
         mdvim7mhJMdk3yaUIGTLRavV22OXdHrkSE7IOieDKKW/F5HIH9hWM8raBwUFyyst0Rvo
         vl8oDrC8jcbHZCaSEz29cs4D9/bvAlhEqKooK+Jtc35dTO8fIiDcb3KNGcL0I59WmpMd
         h0OTHIIPHm7urezkC7wlKM+gjFf81QMT3rSJ6fTO6G3ffE3W7KVr4Z6pVWoNAJjDLDyv
         1dmybG/xE/Sb7pyWUULuZzuCT5rMP5uRyun+2Neu2g/TsGxK7aeTfyExc7vTwLgCoXtd
         D7bw==
X-Gm-Message-State: APjAAAWOQ7m+JMqrQtIfzlKrWT7nBf/iU6fshitRMDzw/71qGsFLWOnf
        Oo3IkecXtq1U5YMqbFH9GUcKqQ==
X-Google-Smtp-Source: APXvYqyLojOfVOxkg0SX7XPNH2zKJXTzuSt/DkeVH9Gngfx3chxempyB5SXHfGVuSTXFOM/6wg4eKQ==
X-Received: by 2002:a25:d40f:: with SMTP id m15mr14169404ybf.21.1556585685170;
        Mon, 29 Apr 2019 17:54:45 -0700 (PDT)
Received: from cakuba (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id n63sm4845729ywf.61.2019.04.29.17.54.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 17:54:45 -0700 (PDT)
Date:   Mon, 29 Apr 2019 20:54:41 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Aya Levin <ayal@mellanox.com>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next RFC] Dump SW SQ context as part of tx reporter
Message-ID: <20190429205441.13c34785@cakuba>
In-Reply-To: <1556547459-7756-1-git-send-email-ayal@mellanox.com>
References: <1556547459-7756-1-git-send-email-ayal@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 17:17:39 +0300, Aya Levin wrote:
> In order to offline translate the raw memory into a human readable
> format, the user can use some out-of-kernel scripts which receives as an
> input the following:
> - Object raw memory
> - Driver object compiled with debug info (can be taken/generated at any time from the machine)
> - Object name

Nice!  IMHO this is more clean, precise and scalable than the fmsg stuff
that we have now.

Would you mind taking the string identifiers down a little bit more?
"memory" could just have a first-class netlink attribute, it doesn't
have to be this fake JSON string pair..
