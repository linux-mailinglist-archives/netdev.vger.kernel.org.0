Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8304CD1B3D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfJIVyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 17:54:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42410 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbfJIVyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 17:54:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so5658749qto.9
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 14:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MO35XIM6bZjoThuh3TCKkSUMsknkNK/iqvjmhlf3GXk=;
        b=sVXddCX4asFKzKDHcG7hg57gec9MX90XhIQqS+2uwrZacvnoBHWkrN8OsXAg69ThJC
         yXXcYuOPvO+I6A6N7P+D18Xf1jxIwjR4g0ADPN6kTfPaBcO6faTiQBSgawJLGK3XF8R0
         /0jJN5NI7RWLG7AO1vir+dN0gHq8XYuoMoCJftcotGSQ/ygNXPAoWAGVr1mivT/8WYI9
         sWZ8ANPVRaWBuIz57NCW5nxQ+moiJiYZRJpYlqmpg84NDaefZcByLaxDYRbluFr3alLq
         GkiS8X2coKdLGOrMcKkSgAJ4yvPA4CcZaNHChlUfUsfzgX7/ppeG8uSeQT3y/eD/v+2G
         HV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MO35XIM6bZjoThuh3TCKkSUMsknkNK/iqvjmhlf3GXk=;
        b=UmXcoJXoWd0IZhDXP2Ydf8bnh5kt0wq2GtWzLzSqzZvFBhteTwvOjMbqYAozw3b651
         CF5zsanyuIuB8+UIvW7yAEkn1PztJpkXXI0lPP2W7nl2mM1VO1SGiJ+psyFiCrcVrwKl
         aJO5I9PdnykCE50B2Ib+VAwSIkdQS6ygwmiFFqx5FMaWf/ex8Xz2SjPzmEJcXZHWs3kq
         hKgH6E+R7Ue4lgxb+dhv86GJSI4jVLc7mCl+s0L3nDWOftjkuSAln3oDyLR/RT0oPS1i
         5VXnZtZzytuIELnMdzcq7K8B0B/erAmoJNma2zrTT1lbXjty7yxJxyBK9QVmuNlR5WvV
         i1zA==
X-Gm-Message-State: APjAAAVaxF+9vLIbihvVFrj5YaJVtKU5qxNRywUaRArWa8gupZxcs5Bn
        h74shgWK/kYWsUw1K2PEApMBIO+MSBc=
X-Google-Smtp-Source: APXvYqxH0//dQ57V0MqFld3wv5l/RWmVSlKYLwkOLEDJQBA/5b9LxzWBqH976AxkAgUvw7T8DWMr0Q==
X-Received: by 2002:aed:3ba9:: with SMTP id r38mr6414496qte.100.1570658041239;
        Wed, 09 Oct 2019 14:54:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x55sm1962732qta.74.2019.10.09.14.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 14:54:01 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:53:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, idosch@mellanox.com, jiri@resnulli.us,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] Documentation: net: fix path to
 devlink-trap-netdevsim
Message-ID: <20191009145345.693710b8@cakuba.netronome.com>
In-Reply-To: <20191009193413.GA25127@splinter>
References: <20191009190621.27131-1-jakub.kicinski@netronome.com>
        <20191009193413.GA25127@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 22:34:13 +0300, Ido Schimmel wrote:
> On Wed, Oct 09, 2019 at 12:06:21PM -0700, Jakub Kicinski wrote:
> > make htmldocs complains:
> > Documentation/networking/devlink-trap.rst:175: WARNING: unknown document: /devlink-trap-netdevsim
> > 
> > make the path relative.
> > 
> > Fixes: 9e0874570488 ("Documentation: Add description of netdevsim traps")
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>  
> 
> Reviewed-by: Ido Schimmel <idosch@mellanox.com>
> 
> Thanks for fixing Jakub.
> 
> FWIW, someone already sent a patch [1] for this, but now I see that it's
> marked as "Not Applicable". Maybe the expectation was that it would go
> via the documentation tree? I just checked and I don't see it there [2].
> 
> [1] https://patchwork.ozlabs.org/patch/1171361/
> [2] git://git.lwn.net/linux.git

Ah, thanks for pointing that out! Looks like some of Jonathan are going
via doc tree :S 

I'll just apply that one then.
