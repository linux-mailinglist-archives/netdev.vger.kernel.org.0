Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132484CD5F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbfFTMDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:03:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:52834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726392AbfFTMDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:03:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AB4FAF03;
        Thu, 20 Jun 2019 12:03:38 +0000 (UTC)
Subject: Re: [PATCH RFC] proc/meminfo: add NetBuffers counter for socket
 buffers
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <155792134187.1641.3858215257559626632.stgit@buzz>
From:   Vlastimil Babka <vbabka@suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=vbabka@suse.cz; prefer-encrypt=mutual; keydata=
 mQINBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABtCBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PokCVAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJcbbyGBQkH8VTqAAoJECJPp+fMgqZkpGoP
 /1jhVihakxw1d67kFhPgjWrbzaeAYOJu7Oi79D8BL8Vr5dmNPygbpGpJaCHACWp+10KXj9yz
 fWABs01KMHnZsAIUytVsQv35DMMDzgwVmnoEIRBhisMYOQlH2bBn/dqBjtnhs7zTL4xtqEcF
 1hoUFEByMOey7gm79utTk09hQE/Zo2x0Ikk98sSIKBETDCl4mkRVRlxPFl4O/w8dSaE4eczH
 LrKezaFiZOv6S1MUKVKzHInonrCqCNbXAHIeZa3JcXCYj1wWAjOt9R3NqcWsBGjFbkgoKMGD
 usiGabetmQjXNlVzyOYdAdrbpVRNVnaL91sB2j8LRD74snKsV0Wzwt90YHxDQ5z3M75YoIdl
 byTKu3BUuqZxkQ/emEuxZ7aRJ1Zw7cKo/IVqjWaQ1SSBDbZ8FAUPpHJxLdGxPRN8Pfw8blKY
 8mvLJKoF6i9T6+EmlyzxqzOFhcc4X5ig5uQoOjTIq6zhLO+nqVZvUDd2Kz9LMOCYb516cwS/
 Enpi0TcZ5ZobtLqEaL4rupjcJG418HFQ1qxC95u5FfNki+YTmu6ZLXy+1/9BDsPuZBOKYpUm
 3HWSnCS8J5Ny4SSwfYPH/JrtberWTcCP/8BHmoSpS/3oL3RxrZRRVnPHFzQC6L1oKvIuyXYF
 rkybPXYbmNHN+jTD3X8nRqo+4Qhmu6SHi3VquQENBFsZNQwBCACuowprHNSHhPBKxaBX7qOv
 KAGCmAVhK0eleElKy0sCkFghTenu1sA9AV4okL84qZ9gzaEoVkgbIbDgRbKY2MGvgKxXm+kY
 n8tmCejKoeyVcn9Xs0K5aUZiDz4Ll9VPTiXdf8YcjDgeP6/l4kHb4uSW4Aa9ds0xgt0gP1Xb
 AMwBlK19YvTDZV5u3YVoGkZhspfQqLLtBKSt3FuxTCU7hxCInQd3FHGJT/IIrvm07oDO2Y8J
 DXWHGJ9cK49bBGmK9B4ajsbe5GxtSKFccu8BciNluF+BqbrIiM0upJq5Xqj4y+Xjrpwqm4/M
 ScBsV0Po7qdeqv0pEFIXKj7IgO/d4W2bABEBAAGJA3IEGAEKACYWIQSpQNQ0mSwujpkQPVAi
 T6fnzIKmZAUCWxk1DAIbAgUJA8JnAAFACRAiT6fnzIKmZMB0IAQZAQoAHRYhBKZ2GgCcqNxn
 k0Sx9r6Fd25170XjBQJbGTUMAAoJEL6Fd25170XjDBUH/2jQ7a8g+FC2qBYxU/aCAVAVY0NE
 YuABL4LJ5+iWwmqUh0V9+lU88Cv4/G8fWwU+hBykSXhZXNQ5QJxyR7KWGy7LiPi7Cvovu+1c
 9Z9HIDNd4u7bxGKMpn19U12ATUBHAlvphzluVvXsJ23ES/F1c59d7IrgOnxqIcXxr9dcaJ2K
 k9VP3TfrjP3g98OKtSsyH0xMu0MCeyewf1piXyukFRRMKIErfThhmNnLiDbaVy6biCLx408L
 Mo4cCvEvqGKgRwyckVyo3JuhqreFeIKBOE1iHvf3x4LU8cIHdjhDP9Wf6ws1XNqIvve7oV+w
 B56YWoalm1rq00yUbs2RoGcXmtX1JQ//aR/paSuLGLIb3ecPB88rvEXPsizrhYUzbe1TTkKc
 4a4XwW4wdc6pRPVFMdd5idQOKdeBk7NdCZXNzoieFntyPpAq+DveK01xcBoXQ2UktIFIsXey
 uSNdLd5m5lf7/3f0BtaY//f9grm363NUb9KBsTSnv6Vx7Co0DWaxgC3MFSUhxzBzkJNty+2d
 10jvtwOWzUN+74uXGRYSq5WefQWqqQNnx+IDb4h81NmpIY/X0PqZrapNockj3WHvpbeVFAJ0
 9MRzYP3x8e5OuEuJfkNnAbwRGkDy98nXW6fKeemREjr8DWfXLKFWroJzkbAVmeIL0pjXATxr
 +tj5JC0uvMrrXefUhXTo0SNoTsuO/OsAKOcVsV/RHHTwCDR2e3W8mOlA3QbYXsscgjghbuLh
 J3oTRrOQa8tUXWqcd5A0+QPo5aaMHIK0UAthZsry5EmCY3BrbXUJlt+23E93hXQvfcsmfi0N
 rNh81eknLLWRYvMOsrbIqEHdZBT4FHHiGjnck6EYx/8F5BAZSodRVEAgXyC8IQJ+UVa02QM5
 D2VL8zRXZ6+wARKjgSrW+duohn535rG/ypd0ctLoXS6dDrFokwTQ2xrJiLbHp9G+noNTHSan
 ExaRzyLbvmblh3AAznb68cWmM3WVkceWACUalsoTLKF1sGrrIBj5updkKkzbKOq5gcC5AQ0E
 Wxk1NQEIAJ9B+lKxYlnKL5IehF1XJfknqsjuiRzj5vnvVrtFcPlSFL12VVFVUC2tT0A1Iuo9
 NAoZXEeuoPf1dLDyHErrWnDyn3SmDgb83eK5YS/K363RLEMOQKWcawPJGGVTIRZgUSgGusKL
 NuZqE5TCqQls0x/OPljufs4gk7E1GQEgE6M90Xbp0w/r0HB49BqjUzwByut7H2wAdiNAbJWZ
 F5GNUS2/2IbgOhOychHdqYpWTqyLgRpf+atqkmpIJwFRVhQUfwztuybgJLGJ6vmh/LyNMRr8
 J++SqkpOFMwJA81kpjuGR7moSrUIGTbDGFfjxmskQV/W/c25Xc6KaCwXah3OJ40AEQEAAYkC
 PAQYAQoAJhYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJbGTU1AhsMBQkDwmcAAAoJECJPp+fM
 gqZkPN4P/Ra4NbETHRj5/fM1fjtngt4dKeX/6McUPDIRuc58B6FuCQxtk7sX3ELs+1+w3eSV
 rHI5cOFRSdgw/iKwwBix8D4Qq0cnympZ622KJL2wpTPRLlNaFLoe5PkoORAjVxLGplvQIlhg
 miljQ3R63ty3+MZfkSVsYITlVkYlHaSwP2t8g7yTVa+q8ZAx0NT9uGWc/1Sg8j/uoPGrctml
 hFNGBTYyPq6mGW9jqaQ8en3ZmmJyw3CHwxZ5FZQ5qc55xgshKiy8jEtxh+dgB9d8zE/S/UGI
 E99N/q+kEKSgSMQMJ/CYPHQJVTi4YHh1yq/qTkHRX+ortrF5VEeDJDv+SljNStIxUdroPD29
 2ijoaMFTAU+uBtE14UP5F+LWdmRdEGS1Ah1NwooL27uAFllTDQxDhg/+LJ/TqB8ZuidOIy1B
 xVKRSg3I2m+DUTVqBy7Lixo73hnW69kSjtqCeamY/NSu6LNP+b0wAOKhwz9hBEwEHLp05+mj
 5ZFJyfGsOiNUcMoO/17FO4EBxSDP3FDLllpuzlFD7SXkfJaMWYmXIlO0jLzdfwfcnDzBbPwO
 hBM8hvtsyq8lq8vJOxv6XD6xcTtj5Az8t2JjdUX6SF9hxJpwhBU0wrCoGDkWp4Bbv6jnF7zP
 Nzftr4l8RuJoywDIiJpdaNpSlXKpj/K6KrnyAI/joYc7
Message-ID: <9f611f72-c883-45e9-cb2a-824ba27356d9@suse.cz>
Date:   Thu, 20 Jun 2019 14:03:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <155792134187.1641.3858215257559626632.stgit@buzz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/19 1:55 PM, Konstantin Khlebnikov wrote:
> Socket buffers always were dark-matter that lives by its own rules.

Is the information even exported somewhere e.g. in sysfs or via netlink yet?

> This patch adds line NetBuffers that exposes most common kinds of them.

Did you encounter a situation where the number was significant and this
would help finding out why memory is occupied?

> TCP and UDP are most important species.
> SCTP is added as example of modular protocol.
> UNIX have no memory counter for now, should be easy to add.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Right now it's a sum of a few values, which should be fine wrt
/proc/meminfo overhead. But I guess netdev guys should have a say in
this. Also you should update the corresponding Documentation/ file.

Thanks,
Vlastimil

> ---
>  fs/proc/meminfo.c  |    5 ++++-
>  include/linux/mm.h |    6 ++++++
>  mm/page_alloc.c    |    3 ++-
>  net/core/sock.c    |   20 ++++++++++++++++++++
>  net/sctp/socket.c  |    2 +-
>  5 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 7bc14716fc5d..0ee2300a916d 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -41,6 +41,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	unsigned long sreclaimable, sunreclaim, misc_reclaimable;
>  	unsigned long kernel_stack_kb, page_tables, percpu_pages;
>  	unsigned long anon_pages, file_pages, swap_cached;
> +	unsigned long net_buffers;
>  	long kernel_misc;
>  	int lru;
>  
> @@ -66,12 +67,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	kernel_stack_kb = global_zone_page_state(NR_KERNEL_STACK_KB);
>  	page_tables = global_zone_page_state(NR_PAGETABLE);
>  	percpu_pages = pcpu_nr_pages();
> +	net_buffers = total_netbuffer_pages();
>  
>  	/* all other kinds of kernel memory allocations */
>  	kernel_misc = i.totalram - i.freeram - anon_pages - file_pages
>  		      - sreclaimable - sunreclaim - misc_reclaimable
>  		      - (kernel_stack_kb >> (PAGE_SHIFT - 10))
> -		      - page_tables - percpu_pages;
> +		      - page_tables - percpu_pages - net_buffers;
>  	if (kernel_misc < 0)
>  		kernel_misc = 0;
>  
> @@ -137,6 +139,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	show_val_kb(m, "VmallocUsed:    ", 0ul);
>  	show_val_kb(m, "VmallocChunk:   ", 0ul);
>  	show_val_kb(m, "Percpu:         ", percpu_pages);
> +	show_val_kb(m, "NetBuffers:     ", net_buffers);
>  	show_val_kb(m, "KernelMisc:     ", kernel_misc);
>  
>  #ifdef CONFIG_MEMORY_FAILURE
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0e8834ac32b7..d0a58355bfb7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2254,6 +2254,12 @@ extern void si_meminfo_node(struct sysinfo *val, int nid);
>  extern unsigned long arch_reserved_kernel_pages(void);
>  #endif
>  
> +#ifdef CONFIG_NET
> +extern unsigned long total_netbuffer_pages(void);
> +#else
> +static inline unsigned long total_netbuffer_pages(void) { return 0; }
> +#endif
> +
>  extern __printf(3, 4)
>  void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3b13d3914176..fcdd7c6e72b9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5166,7 +5166,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>  		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
>  		" unevictable:%lu dirty:%lu writeback:%lu unstable:%lu\n"
>  		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> -		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
> +		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu net_buffers:%lu\n"
>  		" free:%lu free_pcp:%lu free_cma:%lu\n",
>  		global_node_page_state(NR_ACTIVE_ANON),
>  		global_node_page_state(NR_INACTIVE_ANON),
> @@ -5184,6 +5184,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>  		global_node_page_state(NR_SHMEM),
>  		global_zone_page_state(NR_PAGETABLE),
>  		global_zone_page_state(NR_BOUNCE),
> +		total_netbuffer_pages(),
>  		global_zone_page_state(NR_FREE_PAGES),
>  		free_pcp,
>  		global_zone_page_state(NR_FREE_CMA_PAGES));
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 75b1c950b49f..dfca4e024b74 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -142,6 +142,7 @@
>  #include <trace/events/sock.h>
>  
>  #include <net/tcp.h>
> +#include <net/udp.h>
>  #include <net/busy_poll.h>
>  
>  static DEFINE_MUTEX(proto_list_mutex);
> @@ -3573,3 +3574,22 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
>  }
>  EXPORT_SYMBOL(sk_busy_loop_end);
>  #endif /* CONFIG_NET_RX_BUSY_POLL */
> +
> +#if IS_ENABLED(CONFIG_IP_SCTP)
> +atomic_long_t sctp_memory_allocated;
> +EXPORT_SYMBOL_GPL(sctp_memory_allocated);
> +#endif
> +
> +unsigned long total_netbuffer_pages(void)
> +{
> +	unsigned long ret = 0;
> +
> +#if IS_ENABLED(CONFIG_IP_SCTP)
> +	ret += atomic_long_read(&sctp_memory_allocated);
> +#endif
> +#ifdef CONFIG_INET
> +	ret += atomic_long_read(&tcp_memory_allocated);
> +	ret += atomic_long_read(&udp_memory_allocated);
> +#endif
> +	return ret;
> +}
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index e4e892cc5644..9d11afdeeae4 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -107,7 +107,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  			     enum sctp_socket_type type);
>  
>  static unsigned long sctp_memory_pressure;
> -static atomic_long_t sctp_memory_allocated;
> +extern atomic_long_t sctp_memory_allocated;
>  struct percpu_counter sctp_sockets_allocated;
>  
>  static void sctp_enter_memory_pressure(struct sock *sk)
> 

