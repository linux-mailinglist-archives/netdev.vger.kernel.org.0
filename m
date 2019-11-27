Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF5F10C0C8
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 00:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfK0Xpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 18:45:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfK0Xpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 18:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6Ae0SH75w1m9aU+nYBuK6tJIXgbYW1zryuD5lKGbbEg=; b=Qsj7fvhIVgbdW2la4fC0lhgvY
        Wo/EmrP1yYHewA72zmi/WVzozZvWb8lBeLvyml2xaT9VBDnOxnAGHjtQOGxdzIlOC5qV2ZrqnS+NM
        XAUoLDYXcXJgriGImAKwHgBDiYZzXyac48+ufX83dxkhAlzZxijJteCqXkLhGN32LNCOsKAnFutZW
        J6JDmuuZKrNUvGvKITm+V6dJTbkooW0ztS1A42D/+26BEzcL9QXK0lYrleCHS+aLYRzwi2BIt8XEN
        TWKWq16+LWH7khXTfkKIY5EjuREmJ6NUW9bRgnSySIuUNyUiP4inGBQf9tYZGqKGbxGKhq0jltmVN
        kr5sgfsBQ==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ia6zy-0003tM-SR; Wed, 27 Nov 2019 23:45:30 +0000
Subject: Re: linux-next: Tree for Nov 19 (bpf/btf)
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191119194658.39af50d0@canb.auug.org.au>
 <ac0b86e4-611b-81d1-ba09-e819218efe3f@infradead.org>
Message-ID: <8fa2ace8-c3a5-7d7d-b867-9f1c70981541@infradead.org>
Date:   Wed, 27 Nov 2019 15:45:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <ac0b86e4-611b-81d1-ba09-e819218efe3f@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 7:13 AM, Randy Dunlap wrote:
> On 11/19/19 12:46 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20191118:
>>
> 
> on i386 or x86_64:
> 
> ../kernel/bpf/btf.c:3466:1: error: empty enum is invalid
>  };
>  ^
> 
> when CONFIG_NET is not set/enabled.
> 
> 

Still seeing this on linux-next of 20191127.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
