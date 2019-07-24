Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605EC72DD7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfGXLlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:41:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39284 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfGXLlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e0FmIpHpUWwXj3DTaxROxAjjKyPS1Kwl7cbZ+/WDu98=; b=H87CZeMIlYCpEFdY6u+kyyj5H
        dOgStYzGukXfkgUuLHuZC+UAylDCpnouPIN476QxsKBwiRaHCmx4Lo0fJgrgt1X/GV9FW4//Rv3U+
        kfhUUSH0QIp3Xxx65w3dgvoidR60nFHGI6RdgKn3JMn0OoMML1aZ6O+H96BRAlDJPzmtmFInaFbFK
        7XcW3bFEmO0v6FJ7Y+d1TxJRaWYvlhcUzeBoLh9+3HLiD/a0oL69GS8AA6DOmQRvIlCWv3ZVtqodf
        os8t1MBjupkH6ufIo8Fzm+g+ooxBFCQ0VsKk+kocMlwE95meQTKlUsDibsDvKxu4b5NYyLockk9KX
        rZjkl+Drw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hqFe5-00058u-O2; Wed, 24 Jul 2019 11:41:21 +0000
Date:   Wed, 24 Jul 2019 04:41:21 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hch@lst.de" <hch@lst.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Message-ID: <20190724114120.GT363@bombadil.infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
 <20190723030831.11879-7-willy@infradead.org>
 <b47b0b19e5594b97af62352dc0dbffcc@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b47b0b19e5594b97af62352dc0dbffcc@AcuMS.aculab.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:49:03AM +0000, David Laight wrote:
> This is 'just plain stupid'.
> The 'bv_' prefix of the members of 'struct bvec' is there so that 'grep'
> (etc) can be used to find the uses of the members.
> 
> In a 'struct skb_frag_struct' a sensible prefix might be 'sf_'.
> 
> OTOH it might be sensible to use (or embed) a 'struct bvec'
> instead of 'skb_frag_struct'.

Maybe you should read patch 7/7.  Or 0/7.
