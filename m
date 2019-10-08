Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B90CFE82
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfJHQFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:05:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34027 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbfJHQFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:05:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id y35so10516184pgl.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 09:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TYoqnlmN5YGx6tdWtL0BrypNt9tbjb+zxYBUjLstc/E=;
        b=SMcXGyx7ghi+AtoKWR0EMesCZeIjC42tx6oI1MQowVULhCpWZOfPs3yMhI9OIIJshE
         24Ts4MIqNWoabt8bbo0JMeJ3N0HL25nLlPK1MVItILiuaCpSfoEGx+m7jebl7lZaGYXR
         wJOw/1XeTL8fZRpUkk2w+Jq1gf8qbF2/1KBlh5c1pAnU3mgs+z4gZ+0w05Rfl1BvTavU
         Zm3caqcTZLMzWGL1ZJPG+0PrvJrjQIRAEFAqfuMhFuCohcu6FE7TkJWHxMx7MzpAsBk7
         VCtQDkGP9CgWzXPUXSfRuXzWNRat0h4/VJpeyL7pYyr/Zx+Vj8m/UN6bBldz16kIYm79
         nOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TYoqnlmN5YGx6tdWtL0BrypNt9tbjb+zxYBUjLstc/E=;
        b=cpaiMUk6umggm4liXuWkg7xbrfe7bwCvejK/YYOwSvA6rVBrtZhS1m//QczumzneCV
         CSw/aQFwYkadFVvIOjtqc0gck8nIFsuU1gNxbTKGDahFLXctL7SLvtfiVcLCXK3CAwrf
         V/ymsXPzYrKy3qf57voIGyblsOuKlYvsk4e3SHMtTeJVbeUGxBZsiVIjD7juRLYaV0gr
         /oBB5stBNW8co3UGwQsDi8qLD8TaBNiifUvnDQ1auENN2dM1D32fd3tir5Sn2J49kPoa
         4DqeVoBvTaDb2WinqERxyRRXwscSiE/fyTHtVelu2rFKBV7ZWd1J5PhpBbYN/70dGm6J
         R8QA==
X-Gm-Message-State: APjAAAW4HEtpOg2eHwll9hFKMH646NNcK2tBFU8YijEDHKV99wMx9e9s
        vNzGKgzpAwQR2koI0BSe/ClSMQ==
X-Google-Smtp-Source: APXvYqwr+AEGnwsYfkrrmfY9b1RBXzw/yakPQ/QnGuyKWDIX1wMX6ufJSjhvNOXfPENszzmlfUASeA==
X-Received: by 2002:a63:d909:: with SMTP id r9mr36834901pgg.381.1570550728962;
        Tue, 08 Oct 2019 09:05:28 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 1sm20204851pff.39.2019.10.08.09.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 09:05:28 -0700 (PDT)
Date:   Tue, 8 Oct 2019 09:05:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191008090527.53c638c6@hermes.lan>
In-Reply-To: <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
        <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 15:18:53 +0530
Martin Varghese <martinvarghesenokia@gmail.com> wrote:

> +	if (new_mtu > dev->max_mtu)
> +		new_mtu = dev->max_mtu;
> +	else if (new_mtu < dev->min_mtu)
> +		new_mtu = dev->min_mtu;
> +

These checks are already handled as errors in dev_set_mtu_ext()
