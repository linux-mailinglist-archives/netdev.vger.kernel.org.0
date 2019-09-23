Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBF7BBC1D
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 21:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733241AbfIWTQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 15:16:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36694 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbfIWTQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 15:16:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id m18so10502086wmc.1;
        Mon, 23 Sep 2019 12:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N70iF5Ril6x+kuthj8owD8WnByk3GKR1KwVknhgziqU=;
        b=Vtr+dwiIKuQXiTZgLPj4hl0kz+dzNFsR+hqcNBFDW1cVsTXQep+fbZMAU+8ju7Gax6
         KeheXQJmc1K25xdMbr6V+n4XAKwyZDNmqYPR71TD38unLK7dMvP0N8fU/72JpcVTGwxq
         pCowQWgcKtkdGnYId6LE2v0+uGmpauqCD8jtJ/ki6rL6HhmGu0J2Hd7nF/ftTw6XKvoN
         oUXjZYnmm669opWAoZP5rIMP4Y33t2dANKkholNH8D6+ImmZBJ9b2GS5EiCVOWKfieQC
         HSHOt6l0ZYqN5r0OrcrzK2dWYZgDNPTKmcGtfyF2+zFXe2Jk5s8txvAptiNMsZ9dg0L5
         FqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N70iF5Ril6x+kuthj8owD8WnByk3GKR1KwVknhgziqU=;
        b=Ae7V7zM9Eurs8WChlTxwT5aIiSPBNen810fKf+ZRMACFW4NHVHHRCbtyxi+IOW2NHa
         L7pWIouDyq9RFbaKIXmeE1ZDz0tYyNXON9/gGuBwjGjGBWHV2IfxhBjmFQBWXFB5sP7C
         ZnRt5YR51ee8ZRkqveKu+x58suthN4M9Xia/+rXwQNhBDcTrhdWbsFqSKnwaRDSx8uZp
         Bgt6lmBk4tqaov38ICpE2v5wfyryk8/mPh21B3HVtboVx7PXhKhuc/MDSuiwzOvk1iSX
         gne1WdD8BBct2uJqxL9wFHwC5wRU42qSugmXSPWXZIXr5razDlVMT0N3UNAAFdSMgvE0
         Lbsw==
X-Gm-Message-State: APjAAAWQu7kh9VqsBXsKPOkxgnmizZB8/eRgjnuCUDgJZMAn8Qw/rc2j
        AQiys1KdAGmbGIrwwKmDfxfL0EboAaJUbw==
X-Google-Smtp-Source: APXvYqxljmMAEInhWmJYkQWWGT84zJm46FmLzQjSt99ud97QP62BxVPMRy6+h1u4JbXwo4frrDLQKA==
X-Received: by 2002:a1c:a94b:: with SMTP id s72mr853673wme.9.1569266193606;
        Mon, 23 Sep 2019 12:16:33 -0700 (PDT)
Received: from scw-93ddc8.cloud.online.net ([2001:bc8:4400:2400::302d])
        by smtp.gmail.com with ESMTPSA id r28sm24038655wrr.94.2019.09.23.12.16.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 12:16:33 -0700 (PDT)
Date:   Mon, 23 Sep 2019 19:16:26 +0000
From:   Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] VSOCK: add support for MSG_PEEK
Message-ID: <20190923191626.GA2342@scw-93ddc8.cloud.online.net>
References: <1569174507-15267-1-git-send-email-matiasevara@gmail.com>
 <20190923075830.a6sjwffnkljmyyqm@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923075830.a6sjwffnkljmyyqm@steredhat>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 09:58:30AM +0200, Stefano Garzarella wrote:
> Hi Matias,
> thanks for this patch!
> 
> Since this patch only concerns virtio_transport,
> I'd use the 'vsock/virtio' prefix in the commit title:
> "vsock/virtio: add support for MSG_PEEK"
> 
> Some comments below:
> 
> On Sun, Sep 22, 2019 at 05:48:27PM +0000, Matias Ezequiel Vara Larsen wrote:
> > This patch adds support for MSG_PEEK. In such a case, packets are not
> > removed from the rx_queue and credit updates are not sent.
> > 
> > Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
> > ---
> >  net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++++++++++++++--
> >  1 file changed, 56 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 94cc0fa..830e890 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -264,6 +264,59 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
> >  }
> >  
> >  static ssize_t
> > +virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> > +				struct msghdr *msg,
> > +				size_t len)
> > +{
> > +	struct virtio_vsock_sock *vvs = vsk->trans;
> > +	struct virtio_vsock_pkt *pkt;
> > +	size_t bytes, off = 0, total = 0;
> > +	int err = -EFAULT;
> > +
> > +	spin_lock_bh(&vvs->rx_lock);
> > +
> 
> What about using list_for_each_entry() to cycle through the queued packets?
> 
> > +	if (list_empty(&vvs->rx_queue)) {
> > +		spin_unlock_bh(&vvs->rx_lock);
> > +		return 0;
> > +	}
> > +
> > +	pkt = list_first_entry(&vvs->rx_queue,
> > +			       struct virtio_vsock_pkt, list);
> > +	do {
> 
> pkt->off contains the offset inside the packet where the unread data starts.
> So here we should initialize 'off':
> 
> 		off = pkt->off;
> 
> Or just use pkt->off later (without increasing it as in the dequeue).
> 
> > +		bytes = len - total;
> > +		if (bytes > pkt->len - off)
> > +			bytes = pkt->len - off;
> > +
> > +		/* sk_lock is held by caller so no one else can dequeue.
> > +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> > +		 */
> > +		spin_unlock_bh(&vvs->rx_lock);
> > +
> > +		err = memcpy_to_msg(msg, pkt->buf + off, bytes);
> > +		if (err)
> > +			goto out;
> > +
> > +		spin_lock_bh(&vvs->rx_lock);
> > +
> > +		total += bytes;
> 
> Using list_for_each_entry(), here we can just do:
> (or better, at the beginning of the cycle)
> 
> 		if (total == len)
> 			break;
> 
> removing the next part...
> 
> > +		off += bytes;
> > +		if (off == pkt->len) {
> > +			pkt = list_next_entry(pkt, list);
> > +			off = 0;
> > +		}
> > +	} while ((total < len) && !list_is_first(&pkt->list, &vvs->rx_queue));
> 
> ...until here.
> 
> > +
> > +	spin_unlock_bh(&vvs->rx_lock);
> > +
> > +	return total;
> > +
> > +out:
> > +	if (total)
> > +		err = total;
> > +	return err;
> > +}
> > +
> > +static ssize_t
> >  virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >  				   struct msghdr *msg,
> >  				   size_t len)
> > @@ -330,9 +383,9 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> >  				size_t len, int flags)
> >  {
> >  	if (flags & MSG_PEEK)
> > -		return -EOPNOTSUPP;
> > -
> > -	return virtio_transport_stream_do_dequeue(vsk, msg, len);
> > +		return virtio_transport_stream_do_peek(vsk, msg, len);
> > +	else
> > +		return virtio_transport_stream_do_dequeue(vsk, msg, len);
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
> >  
> 
> The rest looks good to me!
> 
> Thanks,
> Stefano
Thanks Stefano. Based on your comments, I will modify the patch and
resubmit it.

Matias
