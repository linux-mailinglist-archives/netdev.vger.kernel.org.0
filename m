Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461325BBA4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfGAMii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:38:38 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36618 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfGAMii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:38:38 -0400
Received: by mail-wr1-f50.google.com with SMTP id n4so13700361wrs.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7OdKOBOEu/IiRXNpUgC/xr2SjNnwUtufZkc62ZD3w7k=;
        b=YNLqqHpgCvD7ZFkr7RNnRPIv4z9Q3csPk6uFefnmQMzgqixiPY2wQAd0xA/ta3798H
         DxN/9VRTVRAb7VefDUtRF3k9g8GPSyXAcrhdiVxerMdLb3wg/ifPjZm/+47BkQ24jdjD
         bBY8npHJbtgpHu8BQUxS0zoZ/E0wWd/wRccX/C6f4WKhZeNcUgdAshPR8v+REKT6lu+S
         dTodUOqbHUupV5ZQQjFkWUz2OOiKiHjuhUO27ix0lxMUhEJs+4ujA+Jy5wD1UibN6lWw
         1G1gFRCEJeIJPqRz0NYtVL9ltM+22m0fQpFxaaRpbg5e5u4Gpi6NhkoBFIv4K28DqNLS
         ITGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7OdKOBOEu/IiRXNpUgC/xr2SjNnwUtufZkc62ZD3w7k=;
        b=BGmuC4rENCLu9yU0UbA4Ee2X3QY16bCaJ9PXaYqYkNStJsZbx3sEDhDCbhfHOPXYbr
         y7sfId32Hz54to3sqFILdK4Kj3qxh7zeEJsRmAKgZJ1SXcHHvLwLrS6i9MdgTkRvZxf1
         wnJUiGm2Hbu02FYFykg2Oml+Fl+fAp3G/zxEbLIaCURLrAe69MjDpqDHK0qPGwds7rbU
         3syJ8ezybkzoHoAw5Z1Lj386r6ni+XPJ2ZlpKy0/dNVhcXyjRhX15zKip8F7/m+82nkT
         6mqfLTGWXy1vPVxb2xH482Lj/gse9lAoRmQs7rad89CINahnjvKmwlasO+oUayX8bDq6
         kHZw==
X-Gm-Message-State: APjAAAVY8vuPcX1GPb/oZU6synb1fbXjSUJL2NjBiFLplqFrbBOhoc/b
        ipdqiWOpdGBOTSrc9EYlVPCaoFa1P0I=
X-Google-Smtp-Source: APXvYqyzCuWh8WfyySHcg0HQQOM9nPZ/AYnmyhSa/XTaeuGSq3xvQgunEhI4MiJAXwLu2yIYI2xtIQ==
X-Received: by 2002:a5d:518f:: with SMTP id k15mr18705158wrv.321.1561984715727;
        Mon, 01 Jul 2019 05:38:35 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:78cb:f345:e2db:cb5a? ([2a01:e35:8b63:dc30:78cb:f345:e2db:cb5a])
        by smtp.gmail.com with ESMTPSA id n125sm14952756wmf.6.2019.07.01.05.38.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 05:38:35 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC iproute2] netns: add mounting state file for each netns
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Alexander Aring <aring@mojatatu.com>
References: <20190630192933.30743-1-mcroce@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <e2173091-1c7a-fd74-95ea-41eedbab92d3@6wind.com>
Date:   Mon, 1 Jul 2019 14:38:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190630192933.30743-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/06/2019 à 21:29, Matteo Croce a écrit :
> When ip creates a netns, there is a small time interval between the
> placeholder file creation in NETNS_RUN_DIR and the bind mount from /proc.
> 
> Add a temporary file named .mounting-$netns which gets deleted after the
> bind mount, so watching for delete event matching the .mounting-* name
> will notify watchers only after the bind mount has been done.
Probably a naive question, but why creating those '.mounting-$netns' files in
the directory where netns are stored? Why not another directory, something like
/var/run/netns-monitor/?


Regards,
Nicolas
